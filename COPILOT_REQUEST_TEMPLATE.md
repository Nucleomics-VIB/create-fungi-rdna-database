# Copilot Request Template

Use this template to ensure consistent AI responses that respect session context and decisions.

## Template to Copy-Paste:

```
[CONTEXT CHECK] Review AI_INSTRUCTIONS.md, CURRENT_CONTEXT.md, and SESSION_DECISIONS.md first.

[YOUR REQUEST HERE - Replace this with your actual question or task]

[REMINDER] Update session documentation if new decisions are made.
```

## For NEW Sessions (Session Recovery):

Start a new session with this template to recover context:

```
[NEW SESSION RECOVERY] Please read AI_INSTRUCTIONS.md, CURRENT_CONTEXT.md, and SESSION_DECISIONS.md to understand our project context. After reading, summarize what you understand about:
1. The current flag meanings and architecture 
2. Major decisions made and problems solved
3. Current state of the project

Then confirm your understanding before proceeding with: [YOUR ACTUAL REQUEST]
```

## Examples:

### For Code Changes:
```
[CONTEXT CHECK] Review AI_INSTRUCTIONS.md, CURRENT_CONTEXT.md, and SESSION_DECISIONS.md first.

Add a new validation check to ensure the sample sheet has the correct format.

[REMINDER] Update session documentation if new decisions are made.
```

### For New Features:
```
[CONTEXT CHECK] Review AI_INSTRUCTIONS.md, CURRENT_CONTEXT.md, and SESSION_DECISIONS.md first.

Add a new flag to enable/disable the archiving step in the pipeline.

[REMINDER] Ensure this doesn't conflict with existing flags and update SESSION_DECISIONS.md.
```

### For Documentation Updates:
```
[CONTEXT CHECK] Review AI_INSTRUCTIONS.md, CURRENT_CONTEXT.md, and SESSION_DECISIONS.md first.

Update the README to include troubleshooting section for common Docker issues.

[REMINDER] Keep consistent with our established architecture decisions.
```

### For Bug Fixes:
```
[CONTEXT CHECK] Review AI_INSTRUCTIONS.md, CURRENT_CONTEXT.md, and SESSION_DECISIONS.md first.

Fix the issue where verbose mode isn't working correctly in the container.

[REMINDER] Maintain consistency with established flag behavior and update docs if needed.
```

## Quick Shortcuts:

For simple questions where you just want me to check context first:
```
[CHECK CONTEXT] [Your question here]
```

For urgent fixes where context is less critical:
```
[QUICK FIX] [Your issue here] [Note: minimal context check needed]
```

## Tips:
- Keep these context files open in VS Code tabs for better visibility
- Use specific references like "according to our SESSION_DECISIONS.md" when pointing out inconsistencies
- Reference specific flag meanings from CURRENT_CONTEXT.md when discussing functionality