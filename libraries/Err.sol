pragma solidity ^0.4.18;

library Err {

  event Error(string message);

  // Halts execution any changes to storage made before calling this WILL be persisted
  function stopExecution() internal pure {
    assembly {
      stop
    }
  }

  function stopIf(bool _assertion, string _msg) internal {
    if (_assertion) {
      Error(_msg);
      stopExecution();
    }
  }

  function stopUnless(bool _assertion, string _msg) internal {
    stopIf(!_assertion, _msg);
  }
}
