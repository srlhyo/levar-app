<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Models\Item;
use App\Models\ItemMedia;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Intervention\Image\ImageManager;
use Throwable;

class ItemMediaController extends Controller
{
    use InteractsWithMoves;

    public function store(Request $request, Item $item): JsonResponse
    {
        $move = $this->authorizeItem($request, $item);

        $data = $request->validate([
            'file' => ['required', 'file', 'image', 'max:10240'],
        ]);

        $file = $data['file'];
        $disk = $this->resolveDisk();
        $directory = "items/{$item->id}";
        $filename = $this->buildFilename($file);

        try {
            $stored = $this->persistUploadedImage($file, $disk, $directory, $filename);
        } catch (Throwable $exception) {
            report($exception);

            return response()->json([
                'message' => 'Não foi possível processar a imagem agora. Tente novamente em instantes.',
            ], 422);
        }

        $media = $item->media()->create([
            'disk' => $disk,
            'path' => $stored['path'],
            'thumb_path' => $stored['thumb_path'],
            'status' => 'done',
            'bytes' => $stored['bytes'],
            'width' => $stored['width'],
            'height' => $stored['height'],
            'mime' => $stored['mime'],
            'uploaded_by' => $request->user()?->id,
        ]);

        $item->update([
            'photo_url' => $stored['url'],
            'thumbnail_url' => $stored['thumb_url'],
        ]);

        return response()->json([
            'media' => [
                'id' => (string) $media->id,
                'url' => $stored['url'],
                'thumb_url' => $stored['thumb_url'],
            ],
        ], 201);
    }

    public function destroy(Request $request, ItemMedia $media): JsonResponse
    {
        $item = $media->item;
        $move = $this->authorizeItem($request, $item);

        $disk = $media->disk;
        $paths = array_filter([$media->path, $media->thumb_path]);
        Storage::disk($disk)->delete($paths);
        $media->delete();

        $cover = $item->media()->orderBy('created_at')->first();

        if ($cover) {
            $coverDisk = $cover->disk;
            $item->update([
                'photo_url' => Storage::disk($coverDisk)->url($cover->path),
                'thumbnail_url' => $cover->thumb_path ? Storage::disk($coverDisk)->url($cover->thumb_path) : null,
            ]);
        } else {
            $item->update([
                'photo_url' => null,
                'thumbnail_url' => null,
            ]);
        }

        return response()->json(['status' => 'ok']);
    }

    private function buildFilename(UploadedFile $file): string
    {
        $extension = $file->getClientOriginalExtension() ?: $file->guessExtension() ?: 'jpg';

        return Str::uuid() . '.' . strtolower($extension);
    }

    private function resolveDisk(): string
    {
        $defaultDisk = config('filesystems.default', 'public');

        return $defaultDisk === 'local' ? 'public' : $defaultDisk;
    }

    private function persistUploadedImage(UploadedFile $file, string $disk, string $directory, string $filename): array
    {
        $storage = Storage::disk($disk);
        $path = null;
        $thumbPath = "{$directory}/thumbs/{$filename}";
        $realPath = $file->getRealPath() ?: $file->getPathname();

        $bytes = (int) $file->getSize();
        $mime = $file->getMimeType();

        try {
            $path = $storage->putFileAs($directory, $file, $filename);

            $storage->makeDirectory(dirname($thumbPath));

            $manager = $this->makeImageManager();
            $width = null;
            $height = null;

            if ($manager && $realPath) {
                $image = $manager->read($realPath);
                $width = $image->width();
                $height = $image->height();

                $thumbImage = $manager->read($realPath)->cover(600, 600);
                $storage->put($thumbPath, $thumbImage->toJpeg(85)->toString());
            } else {
                $dimensions = $realPath ? @getimagesize($realPath) : null;

                if (is_array($dimensions)) {
                    $width = $dimensions[0] ?? null;
                    $height = $dimensions[1] ?? null;
                }

                $storage->put($thumbPath, file_get_contents($realPath ?: $file->getPathname()));
            }

            return [
                'path' => $path,
                'thumb_path' => $thumbPath,
                'bytes' => $bytes,
                'width' => $width,
                'height' => $height,
                'mime' => $mime,
                'url' => $storage->url($path),
                'thumb_url' => $storage->url($thumbPath),
            ];
        } catch (Throwable $exception) {
            if ($path) {
                $storage->delete([$path, $thumbPath]);
            }

            throw $exception;
        }
    }

    private function makeImageManager(): ?ImageManager
    {
        if (extension_loaded('gd')) {
            return ImageManager::gd();
        }

        if (extension_loaded('imagick')) {
            return ImageManager::imagick();
        }

        return null;
    }
}
