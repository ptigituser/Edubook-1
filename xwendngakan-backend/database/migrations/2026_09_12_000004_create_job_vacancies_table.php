<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('job_vacancies', function (Blueprint $table) {
            $table->id();
            $table->foreignId('institution_id')->nullable()->constrained('institutions')->nullOnDelete();
            $table->string('institution_name');
            $table->string('institution_logo')->nullable();
            $table->string('title');
            $table->string('category')->default('teacher'); // teacher, admin, support, other
            $table->string('subject')->nullable(); // بیرکاری، ئینگلیزی، زیندەزانی، هتد
            $table->string('education_level')->nullable(); // باخچە، سەرەتایی، ناوەندی، ئامادەیی، پەیمانگا، زانکۆ
            $table->string('employment_type')->default('full_time'); // full_time, part_time, temporary, contract
            $table->string('city'); // هەولێر، سلێمانی، دهۆک، هتد
            $table->string('salary_range')->nullable(); // مەودای مووچە یان دوای چاوپێکەوتن
            $table->string('gender')->default('any'); // any, female, male
            $table->string('experience_years')->nullable(); // ساڵانی ئەزموون
            $table->text('description');
            $table->text('requirements')->nullable();
            $table->string('contact_phone');
            $table->string('contact_whatsapp')->nullable();
            $table->string('contact_email')->nullable();
            $table->boolean('is_active')->default(true);
            $table->boolean('is_approved')->default(true);
            $table->unsignedBigInteger('views_count')->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('job_vacancies');
    }
};
