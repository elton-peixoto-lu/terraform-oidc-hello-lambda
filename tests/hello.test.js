const test = require("node:test");
const assert = require("node:assert/strict");
const { handler } = require("../lambda/index");

test("lambda returns hello world", async () => {
  const response = await handler();

  assert.equal(response.statusCode, 200);
  assert.deepEqual(JSON.parse(response.body), {
    message: "hello world"
  });
});

test("dummy ci test stays green on work branches", () => {
  assert.equal(2 + 2, 4);
});

