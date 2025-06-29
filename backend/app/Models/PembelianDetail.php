<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PembelianDetail extends Model
{
    protected $table = 'pembelian_details';
    protected $primaryKey = 'id_detail';
    public $timestamps = true;
    protected $fillable = [
        'id_pembelian',
        'id_obat',
        'jumlah',
        'harga_satuan',
        'subtotal',
    ];

    public function pembelian()
    {
        return $this->belongsTo(Pembelian::class, 'id_pembelian', 'id_pembelian');
    }

    public function obat()
    {
        return $this->belongsTo(Obat::class, 'id_obat', 'id_obat');
    }
}
