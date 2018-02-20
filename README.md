# Trufflib

This module has our shared solidity libraries (such as error handling and signature verification)

It also contains helpers which allow us to easily test for the correct events to be emitted and more (in the future)

## Installation

`npm install --save @appliedblockchain/trufflib`

## Usage

### Helpers

We currently only have test helpers
```js
// require test helpers in your truffle test file
const Helpers = require('@appliedblockchain/trufflib/helpers/Test')

// then, in a truffle test
await Helpers.expectErrorEvent(contract.doSomethingBroken(), 'This doesnt work.')
```

See [truffle-examples](https://github.com/appliedblockchain/truffle-examples) for some more usage examples.

### Solidity Libraries

Truffle supports importing contracts (or libraries) from node modules. [Truffle npm package documentation](http://truffleframework.com/docs/getting_started/packages-npm)

```
import "@appliedblockchain/trufflib/libraries/Err.sol";

// then in a function, you can use the Err library
Err.stopUnless(msg.sender == creator, 'Only the creator can set the message.');
```

Again, see [truffle-examples](https://github.com/appliedblockchain/truffle-examples) for some more usage examples.
