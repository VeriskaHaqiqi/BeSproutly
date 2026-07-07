<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ArticleCategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            ['name' => 'Ornamental Plants'],
            ['name' => 'Vegetables'],
            ['name' => 'Food Crops'],
            ['name' => 'Fruit Plants'],
            ['name' => 'Herbs and Kitchen Spices'],
        ];

        DB::table('article_categories')->insert($categories);
    }
}