===============================================================================
                        ⚠️  COPILOT INSTRUCTIONS - READ FIRST ⚠️
===============================================================================

🚨🚨🚨 CRITICAL ARCHITECTURE WARNING FOR DOCKER IMAGES🚨🚨🚨
IF WORKING ON A DOCKER IMAGE, ALL PATHS IN CODE MUST BE RELATIVE TO THE CONTAINER IMAGE, NEVER TO THE HOST!
- Container perspective: `/data/` is the mounted workspace, `/app/` is for application files
- NEVER reference host filesystem paths in container scripts
- Stay within container boundaries at all times
🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨

BEFORE EVERY RESPONSE:
1. Check CURRENT_CONTEXT.md for established decisions
2. Check SESSION_DECISIONS.md for session history  
3. Reference the todo list for active tasks
4. Maintain consistency with previous decisions in THIS session

KEY CONTEXT:
- Flag meanings are established and should not be changed
- Architecture principles are documented and must be followed

WHEN MAKING CHANGES:
- Always update SESSION_DECISIONS.md if new decisions are made
- Reference established flag definitions before adding new ones
- Maintain host/container path separation architecture
- Don't contradict previous decisions without explicit discussion

===============================================================================
                        🔄  FOR NEW SESSIONS (SESSION MEMORY)
===============================================================================

If starting a NEW session and need to recover context:

1. **READ FILES**: AI_INSTRUCTIONS.md → CURRENT_CONTEXT.md → SESSION_DECISIONS.md
2. **TELL USER**: "I read and understood the rules"
3. **ASK**: "Is this understanding correct? Any updates needed?"
4. **MAINTAIN CONSISTENCY**: Never contradict decisions in these files without discussion

This preserves: Technical decisions, flag definitions, problem-solution history, user preferences, code patterns.

===============================================================================