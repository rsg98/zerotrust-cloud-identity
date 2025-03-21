/// <reference types="jest" />
import request from 'supertest';
import { app } from './index';
import express from 'express';
import http from 'http';

// Create our own server instance for testing
let server: http.Server;

beforeAll((done) => {
  // Use port 0 to let the OS assign a random available port
  server = app.listen(0, () => {
    done();
  });
});

afterAll((done) => {
  server.close(done);
});

describe('Express Server', () => {
  it('responds with hello world', async () => {
    const response = await request(app).get('/');
    expect(response.status).toBe(200);
    expect(response.text).toBe('hello world');
  });

  it('responds with hello world for any path', async () => {
    const response = await request(app).get('/any-path-works-too');
    expect(response.status).toBe(200);
    expect(response.text).toBe('hello world');
  });

  // The server initialization, port setting, and console.log are covered
  // by loading the module during test
}); 