<?php
 
 namespace Database\Seeders;
 
 use App\Models\User;
 use App\Models\ExpertProfile;
 use App\Models\Article;
 use App\Models\ArticleCategory;
 use Illuminate\Database\Console\Seeds\WithoutModelEvents;
 use Illuminate\Database\Seeder;
 use Illuminate\Support\Facades\Hash;
 
 class DatabaseSeeder extends Seeder
 {
     use WithoutModelEvents;
 
     /**
      * Seed the application's database.
      */
     public function run(): void
     {
         $this->call([
             ArticleCategorySeeder::class,
         ]);
 
         // Create default User
         $user = User::create([
             'name' => 'User Biasa',
             'email' => 'user@gmail.com',
             'phone' => '081234567890',
             'gender' => 'Male',
             'password' => Hash::make('password'),
             'role' => 'user',
         ]);
 
         // Create default Expert
         $expertUser = User::create([
             'name' => 'Dr. Green (Expert)',
             'email' => 'expert@gmail.com',
             'phone' => '089876543210',
             'gender' => 'Female',
             'password' => Hash::make('password'),
             'role' => 'expert',
         ]);
 
         ExpertProfile::create([
             'user_id' => $expertUser->id,
             'university' => 'Institut Pertanian Bogor',
             'years_of_experience' => 5,
             'description' => 'Spesialis tanaman hias, hortikultura, dan penanggulangan hama tanaman.',
             'bank_name' => 'BCA',
             'account_holder' => 'Dr. Green',
             'account_number' => '1234567890',
             'session_fee' => 50000.00,
             'session_duration' => 30,
             'availability_status' => 'available',
         ]);

         // Create secondary Expert
         $expertUser2 = User::create([
             'name' => 'Prof. Sprout',
             'email' => 'sprout@gmail.com',
             'phone' => '081122334455',
             'gender' => 'Male',
             'password' => Hash::make('password'),
             'role' => 'expert',
         ]);

         ExpertProfile::create([
             'user_id' => $expertUser2->id,
             'university' => 'Hogwarts University',
             'years_of_experience' => 15,
             'description' => 'Pakar herbologi, kultur jaringan, dan kesehatan tanah organik.',
             'bank_name' => 'Mandiri',
             'account_holder' => 'Prof. Sprout',
             'account_number' => '0987654321',
             'session_fee' => 75000.00,
             'session_duration' => 45,
             'availability_status' => 'available',
         ]);
 
         // Fetch categories for articles
         $indoorCat = ArticleCategory::where('name', 'Indoor Plants')->first();
         $pestCat = ArticleCategory::where('name', 'Pest Control')->first();
 
         if ($indoorCat && $pestCat) {
             Article::create([
                 'user_id' => $expertUser->id,
                 'category_id' => $indoorCat->id,
                 'title' => 'Cara Merawat Monstera Deliciosa agar Tumbuh Subur',
                 'content' => 'Monstera deliciosa adalah tanaman hias yang sangat populer. Untuk merawatnya, pastikan mendapat cahaya matahari tidak langsung yang cukup, siram hanya ketika tanah bagian atas terasa kering, dan bersihkan daunnya secara berkala agar fotosintesis maksimal.',
                 'cover_image' => null,
                 'status' => 'published',
             ]);
 
             Article::create([
                 'user_id' => $expertUser2->id,
                 'category_id' => $pestCat->id,
                 'title' => 'Mengatasi Hama Kutu Putih Secara Alami',
                 'content' => 'Kutu putih sering menyerang tanaman hias dan sayuran. Anda bisa mengatasinya secara alami menggunakan campuran air hangat, sabun cuci piring organik, dan minyak nimba (neem oil). Semprotkan larutan ini ke area yang terserang pada sore hari.',
                 'cover_image' => null,
                 'status' => 'published',
             ]);
         }
     }
 }
