# Cyberpunk 2077: Context-Aware Generative Texting

This project creates a bridge between **Cyberpunk 2077's internal game state** (Redscript engine) and **Large Language Models** (LLMs). While standard generative mods allow for generic conversation, this system injects real-time, high-fidelity context—Quest Objectives, Police Heat Levels, and Weather Conditions—into the LLM's system prompt, allowing companions to react dynamically to the player's immediate reality.


## The Difference: Context Matters

Standard LLM integration often feels disconnected from gameplay. This system fixes that by injecting the player's active Quest and current Objective into the prompt pipeline.

| **Standard Generative AI** | **Context-Aware System** |
| :---: | :---: |
| ![No Context](Images/NoContextMessage.png)<br>Witout quest context the character seems unaware of the world._ | ![With Context](Images/WithContextMessage.png)<br>With the quest "Riders on the Storm" being tracked the character knows the current state of the world._ |


## Features & Event Systems

### 1. Dynamic "Heat" Reactivity
The system hooks into the `PreventionSystem` to detect changes in police pursuit levels. It calculates a probability curve based on the threat level (1 Star = Low probability, 5 Stars = 100% probability) to trigger organic reactions.

| **Low Heat (Level 1)** | **Maximum Heat (Level 5)** |
| :---: | :---: |
| ![Heat Level 1](Images/PoliceEventHeatLvl1.png)<br>_Casual warning about minor trouble._ | ![Heat Level 5](Images/PoliceEventHeatLvl5.png)<br>_Urgent, high-stakes reaction._ |


### 2. Environmental Awareness (Weather Monitor)
Using a custom **Polling Monitor Pattern** (to bypass native API limitations), the system tracks changes in `worldRainIntensity`.
* **Light Rain:** Triggers low-priority warnings.
* **Heavy Rain:** Triggers comments on visibility and driving safety.

![Weather Event](Images/WeatherEventMessage.png)
*_Companion reacting to a sudden weather shift._*


## 🧠 Under the Hood: Prompt Engineering

To ensure the LLM adheres to the game's narrative, I engineered structured prompt templates that update dynamically based on game state.

### The "Quest Context" Template
This logic resides in `ContextDataSystem.reds`. It maps raw quest titles to narrative summaries to ensure the AI understands the *stakes*, not just the objective.

```text
MISSION: Riders on the Storm. CONTEXT: My leader, Saul, has been kidnapped by the Wraiths.They are holding him at their camp in Sierra Sonora.
We are currently in the middle of a rescue operation.I am terrified of losing him but trying to stay focused.
There is a dust storm approaching which gives us cover but adds urgency.
CURRENT SITUATION: We are currently:Meet with Panam.React to V based on this specific situation.

