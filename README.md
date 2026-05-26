# Agentforce Workshop

In this workshop, we will build an intelligent service agent from the ground up using Agentforce capabilities on the Salesforce Platform. The agent will be deployed to a public-facing web experience for a charming family-owned specialty food store.

The agent is designed to act as a friendly, knowledgeable shop owner who can:

- Answer cooking and culinary-related questions.
- Recommend ingredients and products (especially one that our shop offered 😉).
- Assist customers with placing orders.
- Support checkout experiences.

Throughout the workshop, participants will gain hands-on experience designing conversational experiences, integrating business logic, and deploying AI-powered customer interactions using Salesforce Agentforce.

What you will learn in this workshop:
- Configure agent service user.
- Build agent with Agent Script.
- Test your agent with Agentforce Testing Center.
- Set up Enhanced Chat v2 and deploy your agent as a first-line-of-service.
- Continuously monitor agent performance and feedback.

## Prerequisites

- **Salesforce Developer Edition (DE)** org. Get a free one at [https://www.salesforce.com/products/free-trial/developer](https://www.salesforce.com/products/free-trial/developer/). 
- **Salesforce CLI** (`sf`). Download and install it from [developer.salesforce.com/tools/sfdxcli](https://developer.salesforce.com/tools/sfdxcli).
- **VS Code** with the **Salesforce Extensions** pack and the **Agentforce DX** extension. 

After you get a DE org and set up your tools, authorize the org so you can start working with it.

## Workshop pre-works
Complete these works prior to workshop day so we can have a clean and smooth start:
- **Turn on Data Cloud**: provision Data 360 for your org follow steps at [https://help.salesforce.com/s/articleView?id=data.c360_a_setup_provision.htm&type=5](https://help.salesforce.com/s/articleView?id=data.c360_a_setup_provision.htm&type=5).
- **Turn on Einstein Generative AI**: enable Einstein Generative AI follow steps at [https://help.salesforce.com/s/articleView?id=ai.generative_ai_enable.htm&type=5](https://help.salesforce.com/s/articleView?id=ai.generative_ai_enable.htm&type=5). Skip step 3 & 4 in aforementioned article.
- **Enable Agentforce**: enable Agentforce in your DE org follow steps at [https://help.salesforce.com/s/articleView?id=ai.agent_setup_enable.htm&type=5](https://help.salesforce.com/s/articleView?id=ai.agent_setup_enable.htm&type=5)
- **Enable Person Account**: enable Person Account in your DE org follow steps at [https://help.salesforce.com/s/articleView?id=sales.account_person_enable.htm&type=5](https://help.salesforce.com/s/articleView?id=sales.account_person_enable.htm&type=5). Be noted you might be asked to create an Account record type as prerequisite of enabling Person Account.
- **Enable Enhanced Chat**: enable Enhanced Chat by going to `Setup` -> search for `Messaging Settings` -> flip `Messaging` toggle on.
- **Enable Digital Experiences**: enable Digital Experiences to support Enhanced Chat web deployment follow steps at [https://help.salesforce.com/s/articleView?id=experience.networks_enable.htm&type=5](https://help.salesforce.com/s/articleView?id=experience.networks_enable.htm&type=5).
- **Deploy agent assets**: deploy our agent assets in `package.xml` to your DE org using VSCode Salesforce extension or below `sf` command.
```bash
sf project deploy start --manifest "manifest\package.xml"
```
## Terminologies
- **Agent**: the term `Agent` alone refers to Agentforce Agent, the one we are building in this workshop. When we need to refer to actual human user we will use term `Human Agent`.
- **Agent User**: the integration user for `Agent` to interact with platform tools and data.
- **Agentforce Builder**: next tier of Salesforce AI agent builder. `Agentforce Builder` supports `Agent Script` and provide a cleaner UI.
- **Subagent**:
- **Enhanced Chat**:

## Workshop Exercises
### Excercise 1: Create Agent User
A dedicated Agent User is required to run Salesforce Agentforce. You can think of Agent User as integration user where it allows Agent to interact with platform tools and data.

Create an Agent User with following settings:

| Setting Type | Setting Name | Note |
| -------- | -------- | -------- |
| License | Einstein Agent | |
| Profile | Einstein Agent User | Althought Agentforce documentation recommended to clone Einstein Agent User profile into a custom one before assigning to Agent User, from our experiment Agent User with custom profile won't be selectable in Agentforce Builder |
| Permission Set | Agentforce Service Agent Object Access | Standard Permission Set |
| Permission Set | Agentforce Service Agent Secure Base | Standard Permission Set |
| Permission Set | Shop Assistant Permission Set | Provide access to our custom agent assets and required object (Order, Product, PriceBook, etc) |
| Permission Set Group | AgentforceServiceAgentUserPsg | Standard Permission Set Group |

### Exercise 2: Create AI Authoring Bundle

### Exercise 3: Create 1st subagent Querry Product

### Exercise 4: Create subagents for cart operation (Add / Remove / Update)

### Excercise 5: Create cart checkout subagent

### Excercise 6: Test Agent with Agentforce Test Center and AgentforceDX

### Excercise 7: Publish Agent and deploy to Enhanced Chat

### Excercise 8: Monitor Agent performance and feedback

### Agentforce Help Documents

- [_Agentforce DX Developer Guide_](https://developer.salesforce.com/docs/einstein/genai/guide/agent-dx.html)
- [_Agent Script_](https://developer.salesforce.com/docs/ai/agentforce/guide/agent-script.html)
- [_Agentforce Vibes Extension_](https://developer.salesforce.com/docs/platform/einstein-for-devs/guide/einstein-overview.html)

- [_Salesforce Extensions for VS Code_](https://developer.salesforce.com/docs/platform/sfvscode-extensions/guide)
- [_Salesforce CLI Setup Guide_](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [_Salesforce DX Developer Guide_](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [_Salesforce CLI Command Reference_](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
