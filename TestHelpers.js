const assert = require('assert')

class TestHelpers {

  /*
  Wait for an event
  @param promise Promise of an action that will generate the target event
  @param filter Function used to identify the target event. This function needs to return true for the target event
  @param args Expected arguments (data) of the event.
              If args is a string, then we will compare it against the event message
  @returns A promise that will will be resolved if the expected event (with the specified params)
          was received, otherwise it will be rejected
  */
  static async expectEvent(promise, filter = () => false, args) {
    const result = await promise
    let event_emitted = false

    for (let i = result.logs.length - 1; i >= 0; i--) {
      const log = result.logs[i]

      if (filter(log.event)) {
        if (event_emitted) {
          assert.fail('Multiple targeted events were emitted for function call')
        }

        if (args != undefined) {
          if (typeof args === 'string') {
            assert.strictEqual(args, log.args.message)
          } else {
            assert.deepStrictEqual(args, log.args)
          }
        } else {
          assert(true)
        }

        event_emitted = true
      }
    }

    if (!event_emitted) {
      assert.fail('No targeted event was emitted')
    }
  }

  static async expectErrorEvent(promise, msg) {
    let result = await promise
    let err_emitted = false
    for (var i = result.logs.length - 1; i >= 0; i--) {
      let log = result.logs[i]
      if (log.event == 'Error') {
        if (err_emitted) {
          assert.fail('Multiple error events were emitted for function call')
        }
        if (msg != undefined) {
          assert.strictEqual(msg, log.args.message)
        } else {
          assert(true)
        }
        err_emitted = true
      }
    }
    if (!err_emitted) {
      assert.fail('No Error event was emitted')
    }
  }

  static async expectThrow(promise) {
    let result = null
    try {
      result = await promise
    } catch (error) {
      // TODO: Check jump destination to destinguish between a throw
      //       and an actual invalid jump.
      const invalidOpcode = error.message.search('invalid opcode') >= 0
      // TODO: When we contract A calls contract B, and B throws, instead
      //       of an 'invalid jump', we get an 'out of gas' error. How do
      //       we distinguish this from an actual out of gas event? (The
      //       testrpc log actually show an 'invalid jump' event.)
      const outOfGas = error.message.search('out of gas') >= 0
      const revert = error.message.search('revert') >= 0
      assert(
        invalidOpcode || outOfGas || revert,
        "Expected throw, got '" + error + "' instead",
      )
      return
    }
    assert.fail('Expected throw not received, got clean result ' + JSON.stringify(result))
  }
}

module.exports = TestHelpers
