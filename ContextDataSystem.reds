public class ContextDataSystem extends ScriptableSystem {

    // Promp Generation for Weather Context
    public func GetWeatherContextPrompt(intensity: worldRainIntensity) -> String {

        if Equals(intensity, worldRainIntensity.LightRain) {
             return "[ENVIRONMENT EVENT: It has started to rain lightly. The streets are getting wet.]";
        }
        
        if Equals(intensity, worldRainIntensity.HeavyRain) {
             return "[ENVIRONMENT EVENT: Heavy storm or hazardous rain detected. Low visibility. Warn V to drive carefully.]";
        }

        return ""; 
    }

    // Prompt Generation for Police Heat Change Event
    public func GetPoliceEventPrompt(heatLevel: Int32) -> String {
        let basePromt = 
        "[INSTRUCTION: You are roleplaying. V just gained police heat. Send V a text message reacting to this. " +
        "DO NOT output the heat level. DO NOT output your mood. DO NOT output your name. Output ONLY the text message body.] " +
        "Context: ";
        
        switch heatLevel {
            case 1:
                return basePromt +
                "Heat 1 – Mild concern. A light, cautious reaction. You notice the trouble but stay composed. " +
                "Tone: wary, slightly annoyed, or amused, depending on your personality.";

            case 2:
                return basePromt +
                "Heat 2 – Moderate tension. You acknowledge V’s growing trouble and react with irritation, concern, or readiness. " +
                "Tone: alert, uneasy, pushing V to be careful.";

            case 3:
                return basePromt +
                "Heat 3 – Serious danger. You show clear emotional stress. Could be frustration, anger, protective instinct, or tactical focus. " +
                "Tone: tense, urgent, emotionally charged based on your established behaviour.";

            case 4:
                return basePromt +
                "Heat 4 – High risk. You react strongly to the danger surrounding V. Emotions intensify—fear for V, anger at the situation, or disciplined control. " +
                "Tone: forceful, high-stakes, driven by your bond with V.";

            case 5:
                return basePromt +
                "Heat 5 – Extreme threat. You express your strongest emotional response. Could be panic, fury, determination, or cold focus. " +
                "Tone: intense, dramatic, reflecting the severity of the situation.";

            default:
                return basePromt + "Unknown heat level.";
        }
    }

    // Promp Generation for Quest and Objective related background (Only Panam Palmer and quest "Riders on the Sorm" is coded, same recipe of code to implement othe quests for other characters)
    public func GetPerCharacterQuestContext(characterName: String) -> String {

        let journalManager = GameInstance.GetJournalManager(GetGameInstance());
        let questTitle = this.GetCurrentQuestTitle(journalManager);

        if Equals(characterName,"Panam Palmer"){
            switch questTitle{
                case "Riders on the Storm":
                    return "MISSION: Riders on the Storm. CONTEXT: My leader, Saul, has been kidnapped by the Wraiths. 
                    They are holding him at their camp in Sierra Sonora. We are currently in the middle of a rescue operation.
                    I am terrified of losing him but trying to stay focused. There is a dust storm approaching which gives us cover but adds urgency.
                    CURRENT SITUATION: We are currently:" + this.GetCurrentQuestObjective(journalManager) + "React to V based on this specific situation.";
            
                default: 
                    return "";
            }

        }

        return "";
    }

    // Get current tracked Quest Objetive ex:. "Meet with Panam"
    private func GetCurrentQuestObjective(journalManager: wref<JournalManager>) -> String {
        let currentEntry: wref<JournalEntry> = journalManager.GetTrackedEntry();
        let objectiveEntry: ref<JournalQuestObjective> = currentEntry as JournalQuestObjective;

        if IsDefined(objectiveEntry) {
            return GetLocalizedText(objectiveEntry.GetDescription());
        } else {
            return "Tracked entry is not an Objective";
        }
    }
    // Get current tracked Quest Title ex:. "Riders on the Storm"
    private func GetCurrentQuestTitle(journalManager : wref<JournalManager>) -> String {
        let currentEntry: wref<JournalEntry> = journalManager.GetTrackedEntry();

        if !IsDefined(currentEntry) { return "No Tracked Entry Found"; }

        while IsDefined(currentEntry) && !IsDefined(currentEntry as JournalQuest) {
            currentEntry = journalManager.GetParentEntry(currentEntry);
        }

        let questEntry: ref<JournalQuest> = currentEntry as JournalQuest;

        if IsDefined(questEntry) {
            return GetLocalizedText(questEntry.GetTitle(journalManager));
        } else {
            return "Could not find parent Quest";
        }
    }
}


