import express from 'express'
import type { Request, Response } from 'express'

const app = express()
const PORT = process.env.PORT || 8080

app.get('*', (req: Request, res: Response) => {
  res.status(200).send('hello world')
})

const server = app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`)
})

export { app, server }
