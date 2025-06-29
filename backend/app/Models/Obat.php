<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Obat extends Model
{
    protected $table = 'obats';
    protected $primaryKey = 'id_obat';
    public $timestamps = true;
    protected $fillable = [
        'nama_obat',
        'stok',
        'harga_beli',
        'harga_jual',
        'expired_date',
        'foto',
    ];
}
