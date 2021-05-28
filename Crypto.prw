//Crypto.prw
// https://tdn.totvs.com/display/tec/PrivSignRSA
// https://tdn.totvs.com/display/tec/PrivVeryRSA
// https://www.sohamkamani.com/nodejs/rsa-encryption/
// https://tdn.totvs.com/display/tec/PrivVeryRSA
// Crypt: SHA256       == 6
// Padding: PKCS1_OAEP == 4

User Function SigCrypt(cKey, cContent, cPass, cErr, )
    Local cCrypted := SHA256(cContent)
    // cKey, cContent, nType, cSign, cErr, nPad
    sSign := PrivSignRSA(cPrivKey, cCrypted, 6, cSign, cErr, 4)

Return
