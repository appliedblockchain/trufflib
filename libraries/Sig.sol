pragma solidity ^0.4.23;

import "./ECVerify.sol";

library Sig {

  event Error(string message);

  struct t {
    bytes32 hash;
  }

  function join(t memory self, bytes32 value) internal pure {
    bytes32 a = self.hash;
    bytes32 b = value;
    bytes memory c = new bytes(64);
    assembly {
      mstore(add(c, 0x20), a)
      mstore(add(c, add(0x20, 32)), b)
    }
    self.hash = keccak256(c);
  }

  function param(t memory self, bytes memory value) internal pure {
    join(self, keccak256(abi.encodePacked(value)));
  }

  function param(t memory self, address value) internal pure {
    join(self, keccak256(abi.encodePacked(value)));
  }

  function param(t memory self, uint value) internal pure {
    join(self, keccak256(abi.encodePacked(value)));
  }

  function param(t memory self, uint8 value) internal pure {
    join(self, keccak256(abi.encodePacked(value)));
  }

  function param(t memory self, bool value) internal pure {
    join(self, keccak256(abi.encodePacked(value)));
  }

  function param_string(t memory self, string value) internal pure {
    join(self, keccak256(abi.encodePacked(value)));
  }

  function verify(t memory self, bytes sig, address address_) internal returns (bool) {
    return ECVerify.ecverify(self.hash, sig, address_);
  }

  function verify(t memory self, bytes sig, bytes publicKey) internal returns (bool) {
    return verify(self, sig, address(keccak256(publicKey)));
  }

  function recover(t memory self, bytes sig) internal returns (bool, address) {
    return ECVerify.ecrecovery(self.hash, sig);
  }

  function stopUnlessVerified(t memory self, bytes sig, address _address) internal {
    if (!verify(self, sig, _address)) {
      emit Error('Invalid signature.');
      assembly { stop() }
    }
  }

}
