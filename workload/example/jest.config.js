/** @type {import('ts-jest').JestConfigWithTsJest} */
module.exports = {
  transform: {
    "^.+\\.tsx?$": "ts-jest",
  },
  testEnvironment: "node",
  collectCoverageFrom: ["*.ts", "!*.test.ts", "!jest.config.js"],
  // Force Jest to exit after all tests are complete
  // This is needed especially in CI environments
  forceExit: true,
  // Set a longer timeout to give the tests time to complete
  testTimeout: 30000,
  // Fail the tests if the coverage is <100%
  coverageThreshold: {
    global: {
      branches: 100,
      functions: 100,
      lines: 100,
      statements: 100,
    },
  },
};
