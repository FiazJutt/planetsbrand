function hash(mapString) {
    var key = "KFJS9p4RUGB9s3Zc";
    var key2 = "9643662578110326";
    return (CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(mapString.substr(0, mapString.length - 1)), CryptoJS.enc.Utf8.parse($(key).val()),
        {
            keySize: 128 / 8,
            iv: CryptoJS.enc.Utf8.parse($(key2).val()),
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        })
    );

}