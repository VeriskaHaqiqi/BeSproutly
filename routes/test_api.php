<?php

Route::get('/test-consult', function () {
    return App\Models\Consultation::latest()->first();
});
