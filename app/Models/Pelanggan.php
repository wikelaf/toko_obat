<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Pelanggan extends Model
{
    //
     protected $table = 'pelanggans';
    protected $primaryKey = 'id_pelanggan';
    public $timestamps = true;
    protected $fillable = [
        'nama',
        'alamat',
        'telepon',
    ];
}
