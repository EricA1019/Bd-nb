# Rendering Issue with Godot 4.5 beta 3

**Date:** 2025-08-13

## Summary

A significant visual rendering bug was encountered in the UI's right-hand panel (`UIRoot/Center/RightPanel`). Despite extensive testing confirming that backend logic, EventBus signals, and data propagation were all functioning correctly, no content would render inside this panel.

## Symptoms

- The `RichTextLabel` (`FeedbackText`) inside the `RightPanel` remained blank during gameplay.
- Direct updates to the `text` property of the `RichTextLabel` were verified via logging and in-test scene tree inspection, but no text appeared visually.
- A fallback debug `Label` was added as a direct child of the `RightPanel`. It also failed to render, even when its `visible` and `text` properties were confirmed to be set correctly.
- The entire `RichTextLabel` was replaced with a standard `Label` node via TDD. The new tests passed, confirming the `Label`'s properties were being updated, but it also failed to render visually in-game.

## Diagnosis

The issue is not with the game's GDScript logic, data flow, or scene tree structure. The problem appears to be a rendering-specific bug within the Godot 4.5 beta 3 engine, localized to that specific `Panel` container or its interaction with its parent `HBoxContainer`. All child nodes of `UIRoot/Center/RightPanel` are affected and do not draw.

## Conclusion & Next Steps

Further attempts to fix this issue by changing scripts or replacing nodes within the existing UI structure are likely to fail. The changes from this debugging session were reverted.

The recommended approach is to investigate the `RightPanel`'s container itself or explore alternative UI layouts to circumvent this apparent engine bug.

## Follow-up (2025-08-15)

- The project was run locally using the Godot binary at `/home/eric/Desktop/Godot_v4.5-beta3_linux.x86_64` and the headless test runner `/home/eric/Desktop/Godot_v4.5-beta5_linux.x86_64` for CI-style runs.
- When launched from the local editor build, the four-panel UI renders correctly and the `RightPanel` shows the `FeedbackText` and `FeedbackLabel` nodes as expected. This suggests the earlier blank-render issue is environment-specific (engine binary / desktop build variant) rather than a logic bug in the project.

- Actions taken:
	- Confirmed `EventBus` events are emitted and received by `res://scenes/Main.tscn` and `res://scripts/systems/Main.gd`.
	- Updated `res://scripts/scenes/Apartment.gd` so that when hosted under `Main` it hides its local feedback nodes to avoid duplicate visible text (keeps nodes present for tests).
	- Replaced unsafe `RichTextLabel.append_bbcode` calls across the project with `append_text` or safe text assignments to work in headless/test environments.

Next steps: re-run the GUT test suite from the same Godot binary used for local runs and iterate on any remaining failing integration tests.
