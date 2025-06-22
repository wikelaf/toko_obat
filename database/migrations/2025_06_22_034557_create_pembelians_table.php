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
        Schema::create('pembelians', function (Blueprint $table) {
              $table->id('id_pembelian');
            $table->date('tanggal');
            $table->unsignedBigInteger('id_pemasok');
            $table->decimal('total_harga', 15, 2);
            $table->foreign('id_pemasok')->references('id_pemasok')->on('pemasoks')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pembelians');
    }
};
