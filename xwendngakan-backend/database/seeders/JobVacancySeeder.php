<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\JobVacancy;
use App\Models\Institution;

class JobVacancySeeder extends Seeder
{
    public function run(): void
    {
        $inst1 = Institution::where('city', 'هەولێر')->first();
        $inst2 = Institution::where('city', 'سلێمانی')->first();
        $inst3 = Institution::where('city', 'دهۆک')->first();

        $sampleJobs = [
            [
                'institution_id'   => $inst1 ? $inst1->id : null,
                'institution_name' => ($inst1 && $inst1->nku) ? $inst1->nku : 'قوتابخانەی نیلۆفەری نموونەیی کچان',
                'institution_logo' => $inst1 ? $inst1->logo : null,
                'title'            => 'مامۆستای زمانی ئینگلیزی بۆ قۆناغی ئامادەیی',
                'category'         => 'teacher',
                'subject'          => 'ئینگلیزی',
                'education_level'  => 'ئامادەیی',
                'employment_type'  => 'full_time',
                'city'             => 'هەولێر',
                'salary_range'     => '٧٠٠،٠٠٠ - ٩٠٠،٠٠٠ د.ع',
                'gender'           => 'female',
                'experience_years' => '٢ ساڵ بەسەرەوە',
                'description'      => 'پێویستمان بە مامۆستایەکی لێهاتووی زمانی ئینگلیزییە بۆ وانەوتنەوە لە پۆلەکانی ١٠ و ١١ و ١٢. پێویستە توانای وانەوتنەوەی بە شێوازی سەردەمیانە هەبێت و هەڵگری بڕوانامەی بەکالۆریۆس بێت لە پەروەردە یان ئادابی ئینگلیزی.',
                'requirements'     => '- بڕوانامەی بەکالۆریۆس لە زمانی ئینگلیزی\n- شارەزایی تەواو لە پرۆگرامی Sunrise\n- ئەزموونی وانەوتنەوەی پێشوو مەرجە',
                'contact_phone'    => '07501234567',
                'contact_whatsapp' => '07501234567',
                'contact_email'    => 'jobs@nilofar.edu.krd',
            ],
            [
                'institution_id'   => $inst1 ? $inst1->id : null,
                'institution_name' => ($inst1 && $inst1->nku) ? $inst1->nku : 'کۆمەڵگەی پەروەردەیی گەشە',
                'institution_logo' => $inst1 ? $inst1->logo : null,
                'title'            => 'مامۆستای بیرکاری بۆ قۆناغی ناوەندی',
                'category'         => 'teacher',
                'subject'          => 'بیرکاری',
                'education_level'  => 'ناوەندی',
                'employment_type'  => 'full_time',
                'city'             => 'هەولێر',
                'salary_range'     => '٦٥٠،٠٠٠ - ٨٥٠،٠٠٠ د.ع',
                'gender'           => 'any',
                'experience_years' => '١ ساڵ بەسەرەوە',
                'description'      => 'کۆمەڵگەکەمان پێویستی بە مامۆستای ماتماتیک (بیرکاری) هەیە بۆ پۆلەکانی ٧، ٨، ٩ بە زمانی کوردی. ژینگەی کارکردن زۆر گونجاوە و هاتوچۆ دابینکراوە.',
                'requirements'     => '- دەرچووی کۆلێژی پەروەردە یان زانست بەشی بیرکاری\n- توانای مامەڵەکردن لەگەڵ تەمەنی هەرزەکاری\n- پابەندبوون بە کاتی دەوام',
                'contact_phone'    => '07504445566',
                'contact_whatsapp' => '07504445566',
                'contact_email'    => 'hr@gasha.krd',
            ],
            [
                'institution_id'   => $inst2 ? $inst2->id : null,
                'institution_name' => ($inst2 && $inst2->nku) ? $inst2->nku : 'باخچەی ساوایانی پەپوولەی گەشاوە',
                'institution_logo' => $inst2 ? $inst2->logo : null,
                'title'            => 'مامۆستا و ڕاهێنەری ساوایان (باخچەی منداڵان)',
                'category'         => 'teacher',
                'subject'          => 'باخچە',
                'education_level'  => 'باخچە',
                'employment_type'  => 'full_time',
                'city'             => 'سلێمانی',
                'salary_range'     => '٥٠٠،٠٠٠ - ٦٥٠،٠٠٠ د.ع',
                'gender'           => 'female',
                'experience_years' => 'ئەزموون لە پێشینەیە',
                'description'      => 'باخچەکەمان لە شاری سلێمانی پێویستی بە دوو مامۆستای میهرەبان هەیە بۆ بەخێوکردن و فێرکردنی سەرەتایی منداڵانی تەمەن ٣ بۆ ٥ ساڵ بە چالاکی و یاری پەروەردەیی.',
                'requirements'     => '- هەڵگری بڕوانامەی پەروەردەی بنەڕەتی یان باخچە\n- ئارامگری و خۆشەویستی بۆ منداڵ\n- توانای فێرکردنی یارییە فیکرییەکان',
                'contact_phone'    => '07701239876',
                'contact_whatsapp' => '07701239876',
                'contact_email'    => 'papula.kg@gmail.com',
            ],
            [
                'institution_id'   => $inst2 ? $inst2->id : null,
                'institution_name' => ($inst2 && $inst2->nku) ? $inst2->nku : 'پەیمانگای تەکنیکی پایەتەخت',
                'institution_logo' => $inst2 ? $inst2->logo : null,
                'title'            => 'کارمەندی کارگێڕی و ژمێریاری',
                'category'         => 'admin',
                'subject'          => 'ژمێریاری',
                'education_level'  => 'پەیمانگا',
                'employment_type'  => 'full_time',
                'city'             => 'سلێمانی',
                'salary_range'     => '٦٠٠،٠٠٠ - ٨٠٠،٠٠٠ د.ع',
                'gender'           => 'any',
                'experience_years' => '٢ ساڵ',
                'description'      => 'پێویستمان بە کارمەندێکی زیرەکە بۆ بەشی تۆماری قوتابیان و ژمێریاری ساڵانە. پێویستە شارەزایی تەواوی لە پرۆگرامەکانی Excel و سیستەمی ژمێریاری هەبێت.',
                'requirements'     => '- دەرچووی کارگێڕی، ئابووری یان ژمێریاری\n- شارەزایی بەرز لە کۆمپیوتەر\n- ئاستی باشی زمانی ئینگلیزی',
                'contact_phone'    => '07709876543',
                'contact_whatsapp' => '07709876543',
                'contact_email'    => 'admin@paytakht.edu.krd',
            ],
            [
                'institution_id'   => $inst3 ? $inst3->id : null,
                'institution_name' => ($inst3 && $inst3->nku) ? $inst3->nku : 'قوتابخانەی نێودەوڵەتی زاخۆ',
                'institution_logo' => $inst3 ? $inst3->logo : null,
                'title'            => 'مامۆستای زانست و زیندەزانی (Biology)',
                'category'         => 'teacher',
                'subject'          => 'زیندەزانی',
                'education_level'  => 'ئامادەیی',
                'employment_type'  => 'full_time',
                'city'             => 'دهۆک',
                'salary_range'     => '٨٠٠،٠٠٠ - ١،٠٠٠،٠٠٠ د.ع',
                'gender'           => 'any',
                'experience_years' => '٢ ساڵ بەسەرەوە',
                'description'      => 'وانەوتنەوەی زیندەزانی بە زمانی ئینگلیزی و کوردی بۆ پۆلەکانی دوانزەهەمی ئامادەیی بەپێی سیستەمی وەزاری کوردستان.',
                'requirements'     => '- بڕوانامەی ماستەر یان بەکالۆریۆس لە زیندەزانی\n- توانای ڕوونکردنەوەی تاقیگەیی\n- توانای قسەکردن بە ئینگلیزی',
                'contact_phone'    => '07507654321',
                'contact_whatsapp' => '07507654321',
                'contact_email'    => 'careers@zakhoschool.com',
            ],
            [
                'institution_id'   => $inst1 ? $inst1->id : null,
                'institution_name' => ($inst1 && $inst1->nku) ? $inst1->nku : 'سەنتەری زمانی ئۆکسفۆرد',
                'institution_logo' => $inst1 ? $inst1->logo : null,
                'title'            => 'ڕاوێژکاری تۆمارکردن و پەیوەندییەکان (Call Center / Reception)',
                'category'         => 'admin',
                'subject'          => 'پەیوەندییەکان',
                'education_level'  => 'سەنتەر',
                'employment_type'  => 'part_time',
                'city'             => 'هەولێر',
                'salary_range'     => '٤٥٠،٠٠٠ - ٦٠٠،٠٠٠ د.ع',
                'gender'           => 'female',
                'experience_years' => 'نوێخواز یان ئەزموونی کەم',
                'description'      => 'پێشوازیکردن لە قوتابیان، تۆمارکردنی ناو بۆ خولەکان، وەڵامدانەوەی پەیوەندی تەلەفۆنی و نامەکانی واتسئەپی سەنتەر لە دەوامی ئێواراندا.',
                'requirements'     => '- کاتی دەوام: 3:00 بۆ 8:00 ئێوارە\n- زمانی کوردی پاراو و عەرەبییەکی مامناوەند\n- خاوەن ئەدەب و ڕەوشتی بەرز لە مامەڵەدا',
                'contact_phone'    => '07503332211',
                'contact_whatsapp' => '07503332211',
                'contact_email'    => 'info@oxford-erbil.com',
            ]
        ];

        foreach ($sampleJobs as $job) {
            JobVacancy::create($job);
        }
    }
}
