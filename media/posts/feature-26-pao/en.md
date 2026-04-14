---
title: "nunomaduro/pao — when your tests talk to the agent"
date: 2026-04-11
category: "Dev Log"
tags: [PHP, PHPUnit, Pest, testing, AI, agent, nunomaduro, pao, Laravel, developer-experience]
locale: en
author: aina@borowski.services
---

Building the chat feature meant writing tests — a lot of them. Unit tests for `ChatService`, feature tests for `ChatController`, integration-style conversation tests that exercise the full state machine. Running those tests in a tight loop while iterating on the implementation surfaces a quiet problem: test output is designed for humans reading a terminal, not for agents reading tool call results.

`nunomaduro/pao` is the fix for that. And it represents something broader worth naming.

The package is authored by [Nuno Maduro](https://nunomaduro.com) — the same person behind Laravel Pint, Collision, and Pest. He introduced the concept in a talk worth watching: [Agent-Optimized PHP Tooling](https://www.youtube.com/watch?v=aOA1m9dFEww).

## What pao does

The package description is precise: *"Agent-optimized output for PHP testing tools."*

PHPUnit and Pest produce output meant to be scanned visually — coloured dots, progress bars, formatted exception traces. When an AI agent runs `php artisan test` and reads the result, it gets the same terminal dump. That is fine for simple cases. For failing tests with long stack traces, nested exceptions, or parallel test output, the signal-to-noise ratio drops.

Pao intercepts the output pipeline and reformats it into a structure that agents can parse reliably: clean JSON when running in an agentic context (detected via `shipfastlabs/agent-detector`), unmodified human-readable output when not. The switch is automatic — no flags, no configuration.

```json
{
  "status": "failed",
  "tests": 42,
  "assertions": 187,
  "failures": [
    {
      "test": "Tests\\Unit\\ChatServiceTest::history_is_capped_at_max_pairs",
      "message": "Expected 20 messages, got 22.",
      "file": "tests/Unit/ChatServiceTest.php",
      "line": 94
    }
  ]
}
```

The agent gets exactly what it needs to locate the failure and understand it. No ANSI codes, no progress bars, no decorative borders.

## How it integrates

Pao ships a Laravel `ServiceProvider` and a Pest plugin, both registered automatically via `composer.json` extras. After `composer require --dev nunomaduro/pao`, there is nothing else to configure. The test runner detects the execution context and selects the appropriate output driver.

Both `frontend` and `blog` services received the package as a dev dependency. It only affects test runs — no production impact, no runtime overhead.

## The concept of pao

"Pao" is shorthand for the broader idea: **agent-optimized tooling**.

The software industry has spent decades building tools for human developers — IDEs with syntax highlighting, terminals with colour output, dashboards with charts. All of that is correct and valuable. But when an AI agent is the primary consumer of a tool's output — running tests, reading logs, parsing build results — human-oriented output formats become friction.

Pao applies this thinking to test runners. The same principle applies to linters (structured JSON errors rather than coloured diffs), build tools (machine-readable summaries rather than ASCII art progress), log formatters (structured fields rather than freeform strings). The pattern is: detect the consumer, emit the appropriate format.

This matters more as AI agents become participants in development loops rather than occasional helpers. An agent that writes code, runs tests, reads the results, and iterates — without a human in the loop for each cycle — needs tooling that speaks its language.

## Why it matters for this project specifically

The chat feature was developed with Claude acting as an active collaborator — suggesting implementations, running tests to verify them, reading failures and iterating. Pao made that loop faster and more reliable. Instead of the agent parsing terminal output heuristically, it received structured failure data it could act on directly.

That is the real argument for pao: not that it is technically clever, but that it closes a gap that quietly slows down human–agent collaboration in PHP projects.
