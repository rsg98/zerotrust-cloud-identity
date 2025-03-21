# Cross Cloud Identities in Zero Trust POC

## What is this?
This repository serves as an artifact demonstrating how federated user and workload identity can be done effectively across multiple cloud services without long lived credentials, or individual credentials for humans for each user (single sign on, or SSO).

GDS invited a number of providers to come together collaboratively in our offices for a day to kick this off, with an expectation that this would receive long term support/maintenance from those providers and the invitation is open to any other providers that wish to contribute the relevant implementation for their domain.

The initial day was set out in [Levels](#levels) to game-ify and provide a easy way to create tests, and measure how everyone was getting on, these levels are useful to clearly show the capability achieved too.

## Infrastructure as code

Everything must be Infrastructure as code, where any bootstrap [ClickOps](https://en.wiktionary.org/wiki/ClickOps) is necessary, providers MUST document this, including full screenshots, and where possible backfill this with Infrastructure as code implementation to at least show drift detection.

We will be using [Terraform](https://www.terraform.io/) for this, and providers should provide examples of how to do this for their domain, this allows us to use the same tooling to bootstrap and test the implementation without having to learn new tooling to just understand what is going on.

## Tests

Tests are provided, to prove everything works, and continues to work.
There are some stubs of tests created by GDS to kick things off and written in GHERKIN so that they can be written in plain english and the providers can create the necessary implementation to prove that it works

## Workload app
There is a simple workload app stub in this repository that can function as a starting point for the providers to build their own workload app, we expect all apps to be written in Typescript and include local unit tests with sufficient coverage to prove the app is working in isolation.


## Levels

### Level 1 

```mermaid
sequenceDiagram
  actor Human
  Human ->> CloudControlPlaneConsole: Login
  CloudControlPlaneConsole ->> Human: 200 OK "hello Human"
```

```gherkin
As a User 
I want to login to the console
So that I can I can interact with the cloud provider
```

### Level 2

```mermaid
sequenceDiagram
  box provider0
  participant 🤖ContiniousDeploymentRunner
  end
  box providerN
  participant CloudControlPlaneAPI
  end
  🤖ContiniousDeploymentRunner ->> CloudControlPlaneAPI: auth
  activate CloudControlPlaneAPI
  CloudControlPlaneAPI ->> 🤖ContiniousDeploymentRunner: 200 OK "hello 🤖ContiniousDeploymentRunner"
  🤖ContiniousDeploymentRunner ->> CloudControlPlaneAPI: terraform apply
  CloudControlPlaneAPI ->> 🤖ContiniousDeploymentRunner: Success
  🤖ContiniousDeploymentRunner ->> CloudControlPlaneAPI: terminate session
  CloudControlPlaneAPI ->> 🤖ContiniousDeploymentRunner: 200 OK
  deactivate CloudControlPlaneAPI
```

```gherkin
As a Continious Deployment runner
I want to use my workload identity to access the cloud
So that I can deploy to the cloud
```

> BOOTSTRAP COMPLETE 🎉

### Level 3

```mermaid
sequenceDiagram
  Human ->> DeployedWorkload: GET /
  box provider0
  participant DeployedWorkload
  end
  DeployedWorkload ->> Human: 200 OK (based on human identity)
```

```gherkin
As a Human
...
```

### Level 4

```mermaid
sequenceDiagram
  Human ->> DeployedWorkload: GET /
  box provider0
  participant DeployedWorkload
  participant DeployedObjectStore
  end
  DeployedWorkload ->> DeployedObjectStore: GET object
  DeployedObjectStore ->> DeployedWorkload: 200 OK (based on workload identity)
  DeployedWorkload ->> Human: 200 OK (based on human identity)
```

```gherkin
As a Human
...
```

### Level 5

```mermaid
sequenceDiagram
  Human ->> DeployedWorkload: GET /
  box provider0
  participant DeployedWorkload
  participant DeployedObjectStore
  end
  DeployedWorkload ->> DeployedObjectStore: GET object
  DeployedObjectStore ->> DeployedWorkload: 200 OK (based on human identity)
  DeployedWorkload ->> Human: 200 OK (based on human identity)
```

```gherkin
As a Human
...
```

### Level 6

```mermaid
sequenceDiagram
  Human ->> DeployedWorkload: GET /
  box provider0
  participant DeployedWorkload
  participant DeployedObjectStore
  end
  DeployedWorkload ->> DeployedObjectStore: GET object
  DeployedObjectStore ->> DeployedWorkload: 200 OK (based on human AND workload identity)
  DeployedWorkload ->> Human: 200 OK (based on human identity)
```

```gherkin
As a Human
...
```

### Level 7

```mermaid
sequenceDiagram
  Human ->> DeployedWorkload: GET /
  box provider0
  participant DeployedWorkload
  end
  box providerN
  participant DeployedObjectStore
  end
  DeployedWorkload ->> DeployedObjectStore: GET object
  DeployedObjectStore ->> DeployedWorkload: 200 OK (based on workload identity)
  DeployedWorkload ->> Human: 200 OK
```

```gherkin
As a Human
...
```

### Level 8

```mermaid
sequenceDiagram
  Human ->> DeployedWorkload: GET /
  box provider0
  participant DeployedWorkload
  end
  box providerN
  participant DeployedObjectStore
  end
  DeployedWorkload ->> DeployedObjectStore: GET object
  DeployedObjectStore ->> DeployedWorkload: 200 OK (based on human identity)
  DeployedWorkload ->> Human: 200 OK
```

```gherkin
As a Human
...
```

### Level 9

```mermaid
sequenceDiagram
  Human ->> DeployedWorkload: GET /
  box provider0
  participant DeployedWorkload
  end
  box providerN
  participant DeployedObjectStore
  end
  DeployedWorkload ->> DeployedObjectStore: GET object
  DeployedObjectStore ->> DeployedWorkload: 200 OK (based on human AND workload identity)
  DeployedWorkload ->> Human: 200 OK
```

```gherkin
As a Human
...
```


### Level 10

```mermaid
sequenceDiagram
  Human ->> DeployedWorkload0: GET /
  box provider0
  participant DeployedWorkload0
  end
  box providerN
  participant DeployedWorkload1
  end
  DeployedWorkload0 ->> DeployedWorkload1: GET /
  DeployedWorkload1 ->> DeployedWorkload0: 200 OK "hello DeployedWorkload0"
```

```gherkin
As a Human
...
```


### Level 11

```mermaid
sequenceDiagram
  Human ->> DeployedWorkload0: GET /
  box provider0
  participant DeployedWorkload0
  end
  box providerN
  participant DeployedWorkload1
  end
  DeployedWorkload0 ->> DeployedWorkload1: GET /
  DeployedWorkload1 ->> DeployedWorkload0: 200 OK "hello Human via DeployedWorkload0"
  DeployedWorkload0 ->> Human: 200 OK "hello Human"
```

```gherkin
As a Human
...
```
