<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Pemasok extends Model
{
    //
    protected $table = 'pemasoks';
    protected $primaryKey = 'id_pemasok';
    public $timestamps = true;
    protected $fillable = [
        'nama',
        'alamat',
        'telepon',
    ];
}
