# Migration: Add Country Field to Students

**Date:** 2026-04-14
**Version:** v2.0.0

## Changes
- Added `country` field to the student data model.
- Updated `database/students.json` with country values for all existing records.
- Updated `src/types.ts` Student interface.
- Updated `src/App.tsx` dashboard table to display the new column.

## Reason
To support international student tracking and improve demographic reporting.
