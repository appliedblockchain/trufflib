pragma solidity ^0.4.18;

library TypeConv {

  function bytesToUint(bytes b) internal pure returns (uint) {
      uint result = 0;
      for (uint i = 0; i < b.length; i++) {
          if (b[i] >= 48 && b[i] <= 57) {
              result = result * 10 + (uint(b[i]) - 48);
          }
      }
      return result;
  }

  function uintToBytes(uint v) internal pure returns (bytes) {
    uint maxlength = 100;
    bytes memory reversed = new bytes(maxlength);
    uint i = 0;
    while (v != 0) {
      uint remainder = v % 10;
      v = v / 10;
      reversed[i++] = byte(48 + remainder);
    }
    bytes memory s = new bytes(i);
    for (uint j = 0; j < i; j++) {
      s[j] = reversed[i - j - 1];
    }
    return s;
  }

  // From https://ethereum.stackexchange.com/questions/884/how-to-convert-an-address-to-bytes-in-solidity/885#885
  function addressToBytes(address x) internal pure returns (bytes b) {
    b = new bytes(20);
    for (uint i = 0; i < 20; i++) {
      b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
    }
    return b;
  }

  function publicKeyToAddress(bytes _public_key) internal pure returns (address _address) {
    require(_public_key.length == 64);
    return address(keccak256(_public_key));
  }
}
