# PropyWeb

Web server serving static frontend app. It contains a custom mix task, which takes static frontend files and copy them to *document root* for serving. Check *Usage* below.

## Development

Change the mix/tasks sources and run *mix compile*.
Afterwards when running *mix help* you can see custom tasks (e.g. *prepare_static*).

## Usage

Call the mix task:
**mix prepare_static --s ../propy_frontend/propy/dist/propy**
