const akun = {
    pemilik: "Ani",
    saldo:0 ,
    setorn(n){
        this.saldo +=n;
        return this.saldo;
    },
};

console.log(akun.pemilik)

class Lampu {
    constructor(ruang){
        this.ruang = ruang;
        this.nyala = false;
    }

    saklar(){
        this.nyala = !this.nyala;
        return `${this.ruang}: ${this.nyala ? "nyala" : "mati"}`;
    }
}

const dapur = new Lampu("Dapur");
const kamar = new Lampu("Kamar");

console.log(dapur.saklar());
console.log(dapur.saklar());
console.log(kamar.saklar());