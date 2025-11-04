<?php

use App\Models\Item;
use App\Models\Move;
use App\Models\User;
use App\Models\ItemMedia;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;

use function Pest\Laravel\post;

it('stores media uploads and generates thumbnails', function () {
    config(['filesystems.default' => 'public']);
    Storage::fake('public');

    $user = User::factory()->create();
    $move = Move::factory()->for($user)->create();
    $item = Item::factory()->forMove($move)->create();

    Sanctum::actingAs($user);

    $image = base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/AcAAgMBg4hXkgAAAABJRU5ErkJggg==');

    $response = post(route('api.media.store', $item), [
        'file' => UploadedFile::fake()->createWithContent('photo.png', $image),
    ]);

    $response->assertCreated();

    /** @var ItemMedia $media */
    $media = $item->media()->first();
    expect($media)->not->toBeNull();

    Storage::disk('public')->assertExists($media->path);
    Storage::disk('public')->assertExists($media->thumb_path);

    $freshItem = $item->fresh();
    expect($freshItem->thumbnail_url)->not->toBeNull();
    expect($freshItem->photo_url)->not->toBeNull();
});
