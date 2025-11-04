<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Models\Item;
use App\Models\ItemMedia;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Intervention\Image\ImageManager;

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
        $defaultDisk = config('filesystems.default', 'public');
        $disk = $defaultDisk === 'local' ? 'public' : $defaultDisk;
        $directory = "items/{$item->id}";
        $filename = Str::uuid() . '.' . $file->getClientOriginalExtension();

        $path = Storage::disk($disk)->putFileAs($directory, $file, $filename);

        $manager = $this->makeImageManager();
        $thumbPath = $directory . '/thumbs/' . $filename;
        $bytes = $file->getSize();

        $width = null;
        $height = null;

        if ($manager) {
            $image = $manager->read($file->getPathname());
            $width = $image->width();
            $height = $image->height();

            $thumb = (clone $image)->cover(400, 400);
            $thumbEncoded = $thumb->toJpeg(80);
            Storage::disk($disk)->put($thumbPath, $thumbEncoded->toString());
        } else {
            $dimensions = @getimagesize($file->getPathname());
            if (is_array($dimensions)) {
                $width = $dimensions[0] ?? null;
                $height = $dimensions[1] ?? null;
            }

            Storage::disk($disk)->put($thumbPath, file_get_contents($file->getPathname()));
        }

        $media = $item->media()->create([
            'disk' => $disk,
            'path' => $path,
            'thumb_path' => $thumbPath,
            'status' => 'done',
            'bytes' => $bytes,
            'width' => $width,
            'height' => $height,
            'mime' => $file->getMimeType(),
            'uploaded_by' => $request->user()?->id,
        ]);

        if (!$item->thumbnail_url) {
            $item->update([
                'photo_url' => Storage::disk($disk)->url($path),
                'thumbnail_url' => Storage::disk($disk)->url($thumbPath),
            ]);
        }

        return response()->json([
            'media' => [
                'id' => (string) $media->id,
                'url' => Storage::disk($disk)->url($media->path),
                'thumb_url' => Storage::disk($disk)->url($media->thumb_path),
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
