# Template R Shiny App (Golem Framework)

This repository is a **template R Shiny application** built with the [Golem](https://golemverse.org/) framework. It is designed for rapid development of modular Shiny dashboards and references [`@ut-effectiveness/GolemKpiSnapshotSuite`](https://github.com/ut-effectiveness/GolemKpiSnapshotSuite) as the parent app.

## Getting Started

1. **Create a New Repo from This Template**
   - Click the "Use this template" button on GitHub to scaffold a new repository.
   - Clone your new repository locally.

2. **Install Dependencies**
   - Make sure you have R installed.
   - Install these required R packages:
     ```r
     remotes::install_github("ThinkR-open/golem")
     remotes::install_github("rstudio/pins")
     remotes::install_github("ut-effectiveness/utHelpR")
     # Install other packages as needed
     ```

3. **Reference Parent App**
   - This app is based on [`@ut-effectiveness/GolemKpiSnapshotSuite`](https://github.com/ut-effectiveness/GolemKpiSnapshotSuite).
   - You can reference code or structure from the parent app as needed.

## Customizing Modules

- **Modules Not in Parent App:**  
  Modules not included in the parent app must be customized to fit your new data sources and requirements.
  - Update the UI and server logic in `R/mod_*` files.
  - Adjust inputs, outputs, and reactivity to match your data.

## Data Querying with Pins and utHelpR

This template is set up to use [`pins`](https://pins.rstudio.com/) and [`utHelpR`](https://github.com/ut-effectiveness/utHelpR) for data access and querying.

### Pins Setup

1. **Configure Pins to Pull from Connect Server**
   - Use utHelpR to simplify board setup and data pulls:
   - Store your credentials securely (use `.Renviron` or another secrets manager).

### SQL Data Pulls

- Use utHelpR to connect and query SQL databases:

- Update your modules to use utHelpR for data connections as needed.

## Development Workflow

- **Run App Locally:**
  ```r
  golem::run_dev()
  ```
- **Build & Deploy:**
  - Use Golem’s functions to build and deploy your app.

## Tips

- See [Golem documentation](https://golemverse.org/) for advanced usage.
- Reference [pins documentation](https://pins.rstudio.com/) and [utHelpR documentation](https://github.com/ut-effectiveness/utHelpR) for details on data querying and server connections.

## License

[MIT](LICENSE)

---

**Parent App Reference:**  
[@ut-effectiveness/GolemKpiSnapshotSuite](https://github.com/ut-effectiveness/GolemKpiSnapshotSuite)
