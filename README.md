# Agentforce Workshop

In this workshop, we will build an intelligent service agent from the ground up using Agentforce capabilities on the Salesforce Platform. The agent will be deployed to a public-facing web experience for a charming family-owned specialty food store.

The agent is designed to act as a friendly, knowledgeable shop owner who can:

- Answer cooking and culinary-related questions.
- Recommend ingredients and products.
- Assist customers with placing orders.
- Support cart and checkout experiences.

Throughout the workshop, participants will gain hands-on experience designing conversational experiences, integrating business logic, and deploying AI-powered customer interactions using Salesforce Agentforce.

What you will learn in this workshop:
- Configure agent service user.
- Build an agent with Agent Script.
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

## Read All About It

- [_Agentforce DX Developer Guide_](https://developer.salesforce.com/docs/einstein/genai/guide/agent-dx.html)
- [_Agent Script_](https://developer.salesforce.com/docs/ai/agentforce/guide/agent-script.html)
- [_Agentforce Vibes Extension_](https://developer.salesforce.com/docs/platform/einstein-for-devs/guide/einstein-overview.html)

- [_Salesforce Extensions for VS Code_](https://developer.salesforce.com/docs/platform/sfvscode-extensions/guide)
- [_Salesforce CLI Setup Guide_](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [_Salesforce DX Developer Guide_](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [_Salesforce CLI Command Reference_](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
