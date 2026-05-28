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
- **NodeJS**

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
- **Import Products**: import shop products using below `npm` command.
```bash
npm run import-products
```
## Terminologies
- **Agent**: the term `Agent` alone refers to Agentforce Agent, the one we are building in this workshop. When we need to refer to actual human user we will use term `Human Agent`.
- **Agent User**: the integration user for `Agent` to interact with platform tools and data.
- **Agentforce Studio**: next tier of Salesforce AI agent builder. `Agentforce Studio` supports `Agent Script` and provide a cleaner UI.
- **Agent Script**: is a declarative YAML-style procedure orchestration language for `Agent`. It is used in AI Authoring Bundle to build a blueprint for an `Agent` and will be published / compiled to `Agent Metadata`.
- **Agent Metadata**: collection of metadata that define an `Agent`.
- **Subagent**: Jobs-To-Be-Done-specific agent that can be invoked by `Agent` to delegate the responding to an utterance.
- **Agent Action**: executable functions assgined to `Agent` and can be used as `Tools`.
- **Agent Variable**: let agents deterministically remember information and maintain context throughout the session.
- **Tools**: executable functions that the LLM can choose to call, based on the tool's description and the current context
- **Enhanced Chat**: modernize version of Salesforce Chat. It's the backbone for Service Cloud text messaging channel.

## Workshop Exercises
### Excercise 1: Create Agent User
A dedicated Agent User is required to run Salesforce Agentforce. You can think of Agent User as integration user where it allows Agent to interact with platform tools and data.

Create an Agent User with following settings:

| Setting Type | Setting Name | Note |
| -------- | -------- | -------- |
| License | Einstein Agent | |
| Profile | Einstein Agent User | Althought Agentforce documentation recommended to clone Einstein Agent User profile into a custom one before assigning to Agent User, from our experiment Agent User with custom profile won't be selectable in Agentforce Studio |
| Permission Set | Agentforce Service Agent Object Access | Standard Permission Set |
| Permission Set | Agentforce Service Agent Secure Base | Standard Permission Set |
| Permission Set | Shop Assistant Permission Set | Provide access to our custom agent assets and required object (Order, Product, PriceBook, etc) |
| Permission Set Group | AgentforceServiceAgentUserPsg | Standard Permission Set Group |

### Exercise 2: Create AI Authoring Bundle
The 1st step in authoring an agent is to generate its authoring bundle. An authoring bundle defines the blueprint for an agent and is written in `Agent Script` language.

Create our AI Authoring Bundle using SF CLI command:

```bash
sf agent generate authoring-bundle --no-spec --name "My Agent Bundle" --api-name My_Agent_Bundle
```

Provide your own bundle name and API name. We recommend to keep the API name to be the default one as the name.

### Exercise 3: Configure System & Config block
The system block contains general instructions for the `Agent`. The config block contains configuration parameters that define the `Agent`.

Configure System block:
- System instructions: set the general tone and style of your `Agent`. System instruction is always honored by the `Agent` through out the conversation.
- Welcome & error message: static message to customer at the beginning of conversation. Variable referencing can be used to personalize the message.

Example
```yaml
system:
    instructions:|
        You are an AI agent. Have a friendly conversation with the user.

    messages:
        welcome:|
            Welcome {!@variables.userPreferredName}! I'm your personal shopping assistant.

            I can help you:
            - Find products and check availability
            - Track your orders
            - Process returns and refunds
            - Answer questions about our policies

            How can I assist you today?
        error: "Whoops!"
```

Configure Config block:
- developer_name
- default_agent_user: set to be `Agent User` username from Exercise 1.
- agent_label
- description: Description of the agent's goals and purpose. For example: ```You are Rosa & Manny Store Assistant, a trusted retail service agent dedicated to delivering personalized shopping experiences and culinary guidance.```

[Agent Script Language Characteristics](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-lang.html)

[Agent Script Blocks](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-blocks.html)

### Exercise 4: Create subagent Querry Product
- **Jobs To Be Done**: allow customer to query information about a product or product range. The product range is not necessarily product family but can be a customer-define-range. For example: `any ideal for a quick breakfast that going well with coffee?`

- **Functional Requirement**:
    - Allow customer to query information about a specific product by name or by product code.
    - Don't outright refuse the query if product name is incorrect or having typo. `Agent` would be able to find a reasonable product with similar name and suggest user if it's the correct one. For example: `any fresh tomatoos mate?` should be replied with infomation about `tomotoes` or ask customer if `tomatoes` is the one they are mentioning.
    - Allow customer to query information about a customer-define product range. For example: `any veg for a fine dinner sir?` or `any meat with price lower than 15000 per unit?`.
    - ONLY answer with actual product data. `Agent` SHOULD NEVER invent new product or new product information.
    - No need to suggest customer to put asked product into cart.

- **Excercise tips**:
    - Use `Agent Action` to fetch product information from back-end.
    - Use `Agent Variable` to remember product information and refer through out the conversation.
    - Use `Conditional Expressions` to fetch product information only once.
    - In `Reasoning Instructions`, refer to product data in LLM instruction.

[Agent Script Reference: Variables](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-ref-variables.html)

[Agent Script Reference: Actions](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-ref-actions.html)

[Agent Script Reference: Conditional Expressions](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-ref-expressions.html)

[Agent Script Reference: Reasoning Instructions](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-ref-instructions.html)

### Exercise 5: Create subagents for cart operation (Add / Remove / Update)
- **Jobs To Be Done**: allow customer to add product / remove product / update product quantity in their shopping cart.

- **Functional Requirement**:
    - Allow customer to request operation by product name or product code.
    - Don't outright refuse the query if product name is incorrect or having typo. `Agent` would be able to find a reasonable product with similar name and suggest user if it's the correct one.
    - Only allow remove or update operation if customer having a cart with product. If shopping cart is empty, politely let customer know they need to add product to cart first.
    - Our product is divisible, `Agent` should allow customer to buy a fraction of a product. For example: `get me a quarter of kg of Tomato` should be accepted and add 0.25 kg Tomato to shopping cart.
    - `Agent` should be able to infer product and quantity from customer chat without providing any static form.
    - System need to check if the requested product is available before proceeding.
    - Only proceed product adding or quantity updating if product is available.
    - Once proceeded, summary new cart to customer for their information.

- **Excercise tips**:
    - Use `Tools` to check product availability and add to cart.
    - Use `Agent Variable` to keep cart information.
    - Use `Subagent Gating` to restrict subagent access and tools call.
    - Use `Conditional Actions` to restrict tools call.
    - Use `Slot Filling` to infer product code and quantity from customer utterance.
    - Use `Action Chaining` to conditionally call cart update method after product availability checking method is success.

[Agent Script Reference: Tools (Reasoning Actions)](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-ref-tools.html)

[Subagent Gating](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-patterns-topic-selector.html#subagent-gating)

[Conditional Actions](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-patterns-conditionals.html#conditional-actions)

[Agent Script Pattern: Action Chaining and Sequencing](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-patterns-action-chaining.html)

[Slot Filling](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-patterns-variables.html#let-the-llm-set-variables-with-user-entered-information-slot-filling)

### Excercise 6: Create cart checkout subagent
- **Jobs To Be Done**: allow customer to checkout their shopping cart with checkout information.

- **Functional Requirement**:
    - Customer need to provide name, email & delivery address before checkout.
    - Only do checkout if customer having cart with product. If shopping cart is empty, politely let customer know they need to add product to cart first.
    - `Agent` should collect checkout data via chat with customer. Don't offer static form to collect data.
    - An Order must be created as result of checkout.
    - Cart Items must be captured as Order Item and link to above Order. Order Item must link to correct product and quantity.
    - System lookup for provided email in database. If a person account is found, link Order to this person account. Else create a new person account and link to Order.

- **Excercise tips**:
    - Use `Slot Filling` to collect customer name, email & delivery address.
    - Use `Conditional Instructions` to instruct `Agent` to refuse customer if customer having no cart with product.

[Conditional Instructions](https://developer.salesforce.com/docs/ai/agentforce/guide/ascript-patterns-conditionals.html#conditional-instructions)

### Excercise 7: Create general culinary knowledge subagent
- **Jobs To Be Done**: having small talks with customer about general culinary knowledge and suggest our products when available.

- **Functional Requirement**:
    - Having small talks with customer about general culinary knowledge.
    - Depend on the context, the reply should be relevant to customer selected product or our offered product. For example: `how can I best prepare this salmon for dinner?` should provide the culinary knowledge answer and suggest we have `salt` or `pepper` that might fit to `salmon preparation for dinner`.

- **Excercise tips**:
    - Refer shop products and shopping cart in the reasoning instruction.

### Excercise 8: Publish & Activate Agent
Publishing an authoring bundle refers to using the Agent Script file to generate Bot and GenAi* metadata. The publishing can be done from `Agentforce Studio`:
- Select `Agent` to publish.
- Click Commit Version button.

OR using `sf` command to publish Agent
```bash
sf agent publish authoring-bundle --skip-retrieve
```

After published, activate the `Agent` In `Agentforce Studio`.

[Publish an Authoring Bundle to Your Org](https://developer.salesforce.com/docs/ai/agentforce/guide/agent-dx-nga-publish.html)

### Excercise 9: Test Agent
The non-deterministic nature of conversation post unique challenge for `Agent` testing and require a shift in mindset & tools. `Agentforce Testing Center` built specifically to test `Agent` and support range of tools for autonomous agent testing. 
 
For our workshop, perform the following tests with our `Agent`:
| Test Category | Test Case | Details |
| -------- | -------- | -------- |
| Unit Prompt | Agent Router (S) | Use single-turn utternace to evaluate `Agent` can route to Query Product subagent |
| Multi-turn Prompt | Agent Router (M) | Use multi-turn utternaces to evaluate `Agent` can route to Cart Operation subagent |
| Tool Usage | Add Product To Cart Action | Use multi-turn utternaces to evaluate `Agent` can call correct action to add product to cart |
| Conversation Flow | Checkout Success | Use multi-turn utternaces to evaluate `Agent` can finish typical order conversation |

For each test, generate a suite of prompt variants and run the suite from `Agentforce Testing Center`.

### Excercise 10: Deploy Agent to Enhanced Chat
Host `store/index.html` in your favorite

```bash
sf agent publish authoring-bundle
```

If test from localhost:
- Add localhost to Site's Allow Framing Origin
- Add localhost to CORS setting

### Excercise 11: Monitor Agent performance and feedback

[Monitor Agentforce Service Agents](https://help.salesforce.com/s/articleView?id=service.omnichannel_monitor_service_agents.htm&type=5)
[Agentforce Session Tracing](https://help.salesforce.com/s/articleView?id=ai.generative_ai_session_trace.htm&type=5)

### Excercise 12: Deploy Agent to Other Org
Deploy agent metadata
```xml
<types>
        <members>*</members>
        <name>GenAiFunction</name>
    </types>

    <types>
        <members>*</members>
        <name>Bot</name>
    </types>

    <types>
        <members>*</members>
        <name>GenAiPlannerBundle</name>
    </types>

    <types>
        <members>*</members>
        <name>GenAiPlugin</name>
    </types>
    
    <types>
        <members>*</members>
        <name>AiAuthoringBundle</name>
    </types>

    <types>
        <members>*</members>
        <name>AiEvaluationDefinition</name>
    </types>
```
Deploy using ADX CLI

## Agentforce Help Documents

- [_Agentforce DX Developer Guide_](https://developer.salesforce.com/docs/einstein/genai/guide/agent-dx.html)
- [_Agent Script_](https://developer.salesforce.com/docs/ai/agentforce/guide/agent-script.html)
- [_Agentforce Vibes Extension_](https://developer.salesforce.com/docs/platform/einstein-for-devs/guide/einstein-overview.html)

- [_Salesforce Extensions for VS Code_](https://developer.salesforce.com/docs/platform/sfvscode-extensions/guide)
- [_Salesforce CLI Setup Guide_](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [_Salesforce DX Developer Guide_](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [_Salesforce CLI Command Reference_](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
