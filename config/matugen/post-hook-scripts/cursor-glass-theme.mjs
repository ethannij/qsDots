#!/usr/bin/env node
// Publish the matugen palette to Cursor's Agents window.
// That window (glass) does not read workbench.colorTheme. It stores its own
// theme under glass.theme.* in Cursor's state database.

import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { createRequire } from "node:module";
import { DatabaseSync } from "node:sqlite";

const require = createRequire(import.meta.url);
const home = os.homedir();
const colorsFile = path.join(home, ".cache/matugen/vscode-colors");
const dbPath = path.join(home, ".config/Cursor/User/globalStorage/state.vscdb");
const themeId = "matugen";
const settingsId = `cursor-custom-theme:${themeId}`;
const themesKey = "glass.theme.customThemesV1";

// Glass token -> workbench color id, from Cursor's glass theme importer.
const tokenToVscode = {
  sidebar: "sideBar.background",
  chrome: "panel.background",
  pane: "editor.background",
  elevated: "editor.background",
  base: "editor.foreground",
  accent: "button.background",
  accentFill: "button.background",
  accentForegroundBright: "button.background",
  onPrimary: "button.foreground",
  brand: "charts.blue",
  focus: "focusBorder",
  success: "terminal.ansiGreen",
  successFill: "terminal.ansiGreen",
  successFillHover: "terminal.ansiGreen",
  successFillPressed: "terminal.ansiGreen",
  successFillBright: "terminal.ansiGreen",
  successForeground: "terminal.ansiGreen",
  successForegroundHover: "terminal.ansiGreen",
  successForegroundBright: "terminal.ansiGreen",
  warn: "list.warningForeground",
  warnFill: "list.warningForeground",
  warnFillHover: "list.warningForeground",
  warnFillPressed: "list.warningForeground",
  warnFillBright: "list.warningForeground",
  warnForeground: "list.warningForeground",
  warnForegroundHover: "list.warningForeground",
  warnForegroundBright: "list.warningForeground",
  danger: "errorForeground",
  dangerFill: "errorForeground",
  dangerFillHover: "errorForeground",
  dangerFillPressed: "errorForeground",
  dangerFillBright: "errorForeground",
  dangerForeground: "errorForeground",
  dangerForegroundHover: "errorForeground",
  dangerForegroundBright: "errorForeground",
  added: "gitDecoration.addedResourceForeground",
  addedForegroundBright: "gitDecoration.addedResourceForeground",
  modified: "gitDecoration.modifiedResourceForeground",
  modifiedForegroundBright: "gitDecoration.modifiedResourceForeground",
  removed: "gitDecoration.deletedResourceForeground",
  removedForegroundBright: "gitDecoration.deletedResourceForeground",
  untracked: "gitDecoration.untrackedResourceForeground",
  untrackedForegroundBright: "gitDecoration.untrackedResourceForeground",
  terminalAnsiBlack: "terminal.ansiBlack",
  terminalAnsiRed: "terminal.ansiRed",
  terminalAnsiYellow: "terminal.ansiYellow",
  terminalAnsiGreen: "terminal.ansiGreen",
  terminalAnsiCyan: "terminal.ansiCyan",
  terminalAnsiBlue: "terminal.ansiBlue",
  terminalAnsiMagenta: "terminal.ansiMagenta",
  terminalAnsiWhite: "terminal.ansiWhite",
  terminalAnsiBrightBlack: "terminal.ansiBrightBlack",
  terminalAnsiBrightRed: "terminal.ansiBrightRed",
  terminalAnsiBrightYellow: "terminal.ansiBrightYellow",
  terminalAnsiBrightGreen: "terminal.ansiBrightGreen",
  terminalAnsiBrightCyan: "terminal.ansiBrightCyan",
  terminalAnsiBrightBlue: "terminal.ansiBrightBlue",
  terminalAnsiBrightMagenta: "terminal.ansiBrightMagenta",
  terminalAnsiBrightWhite: "terminal.ansiBrightWhite",
  red: "charts.red",
  redFill: "charts.red",
  redFillHover: "charts.red",
  redFillPressed: "charts.red",
  redFillBright: "charts.red",
  redForeground: "charts.red",
  redForegroundHover: "charts.red",
  redForegroundBright: "charts.red",
  orange: "charts.orange",
  orangeFill: "charts.orange",
  orangeFillHover: "charts.orange",
  orangeFillPressed: "charts.orange",
  orangeFillBright: "charts.orange",
  orangeForeground: "charts.orange",
  orangeForegroundHover: "charts.orange",
  orangeForegroundBright: "charts.orange",
  yellow: "charts.yellow",
  yellowFill: "charts.yellow",
  yellowFillHover: "charts.yellow",
  yellowFillPressed: "charts.yellow",
  yellowFillBright: "charts.yellow",
  yellowForeground: "charts.yellow",
  yellowForegroundHover: "charts.yellow",
  yellowForegroundBright: "charts.yellow",
  green: "charts.green",
  greenFill: "charts.green",
  greenFillHover: "charts.green",
  greenFillPressed: "charts.green",
  greenFillBright: "charts.green",
  greenForeground: "charts.green",
  greenForegroundHover: "charts.green",
  greenForegroundBright: "charts.green",
  cyan: "terminal.ansiCyan",
  cyanFill: "terminal.ansiCyan",
  cyanFillHover: "terminal.ansiCyan",
  cyanFillPressed: "terminal.ansiCyan",
  cyanFillBright: "terminal.ansiCyan",
  cyanForeground: "terminal.ansiCyan",
  cyanForegroundHover: "terminal.ansiCyan",
  cyanForegroundBright: "terminal.ansiCyan",
  blue: "terminal.ansiBlue",
  blueFill: "terminal.ansiBlue",
  blueFillHover: "terminal.ansiBlue",
  blueFillPressed: "terminal.ansiBlue",
  blueFillBright: "terminal.ansiBlue",
  blueForeground: "terminal.ansiBlue",
  blueForegroundHover: "terminal.ansiBlue",
  blueForegroundBright: "terminal.ansiBlue",
  magenta: "terminal.ansiMagenta",
  magentaFill: "terminal.ansiMagenta",
  magentaFillHover: "terminal.ansiMagenta",
  magentaFillPressed: "terminal.ansiMagenta",
  magentaFillBright: "terminal.ansiMagenta",
  magentaForeground: "terminal.ansiMagenta",
  magentaForegroundHover: "terminal.ansiMagenta",
  magentaForegroundBright: "terminal.ansiMagenta",
  purple: "charts.purple",
  purpleFill: "charts.purple",
  purpleFillHover: "charts.purple",
  purpleFillPressed: "charts.purple",
  purpleFillBright: "charts.purple",
  purpleForeground: "charts.purple",
  purpleForegroundHover: "charts.purple",
  purpleForegroundBright: "charts.purple",
  brown: "charts.orange",
  brownFill: "charts.orange",
  brownFillHover: "charts.orange",
  brownFillPressed: "charts.orange",
  brownFillBright: "charts.orange",
  brownForeground: "charts.orange",
  brownForegroundHover: "charts.orange",
  brownForegroundBright: "charts.orange",
  diffAddedLineBackground: "diffEditor.insertedLineBackground",
  diffAddedTextBackground: "diffEditor.insertedTextBackground",
  diffRemovedLineBackground: "diffEditor.removedLineBackground",
  diffRemovedTextBackground: "diffEditor.removedTextBackground",
};

function findExtension() {
  const root = path.join(home, ".cursor/extensions");
  const dirs = fs
    .readdirSync(root)
    .filter((name) => name.startsWith("haikalllp.matugen-theme-"))
    .sort();
  if (dirs.length === 0) {
    throw new Error("Matugen Theme extension is not installed in Cursor");
  }
  return path.join(root, dirs.at(-1));
}

function buildWorkbenchTheme() {
  const extension = findExtension();
  const Color = require(path.join(extension, "node_modules/color"));
  const template = require(path.join(extension, "out/template.js")).default;
  const lines = fs
    .readFileSync(colorsFile, "utf8")
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean);
  return template(lines.map((line) => Color(line)), false);
}

function glassDefinition(theme) {
  const appearance = theme.type === "light" ? "light" : "dark";
  const definition = {
    name: "Matugen",
    appearance,
    highContrast: false,
  };
  for (const [token, vscodeId] of Object.entries(tokenToVscode)) {
    const ids = token === "elevated" ? ["dropdown.background", vscodeId] : [vscodeId];
    for (const id of ids) {
      const value = theme.colors[id];
      if (typeof value === "string" && value.startsWith("#")) {
        definition[token] = value;
        break;
      }
    }
  }
  return { appearance, definition };
}

function put(db, key, value) {
  db.prepare(
    "INSERT INTO ItemTable (key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value",
  ).run(key, value);
}

function get(db, key) {
  return db.prepare("SELECT value FROM ItemTable WHERE key = ?").get(key)?.value;
}

const settingsPath = path.join(home, ".config/Cursor/User/settings.json");

function applyEditorSurfaces(theme) {
  if (!fs.existsSync(settingsPath)) return;
  const codeSurface = theme.colors["editorWidget.background"] || theme.colors["sideBar.background"];
  const quoteBorder = theme.colors["focusBorder"] || theme.colors["button.background"];
  if (!codeSurface) return;

  const settings = JSON.parse(fs.readFileSync(settingsPath, "utf8"));
  const custom = settings["workbench.colorCustomizations"] ?? {};
  custom["textCodeBlock.background"] = codeSurface;
  custom["textBlockQuote.background"] = codeSurface;
  if (quoteBorder) custom["textBlockQuote.border"] = quoteBorder;
  settings["workbench.colorCustomizations"] = custom;
  fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 4) + "\n");
}

function main() {
  if (!fs.existsSync(colorsFile) || !fs.existsSync(dbPath)) {
    console.error("cursor-glass-theme: matugen colors or Cursor state db missing, skipping");
    return;
  }

  const theme = buildWorkbenchTheme();
  const { appearance, definition } = glassDefinition(theme);
  applyEditorSurfaces(theme);
  const db = new DatabaseSync(dbPath);
  db.exec("PRAGMA busy_timeout = 5000");

  let store = { _v: 1, themes: {} };
  const existing = get(db, themesKey);
  if (typeof existing === "string" && existing.length > 0) {
    try {
      const parsed = JSON.parse(existing);
      if (parsed && typeof parsed === "object") store = parsed;
    } catch {
      store = { _v: 1, themes: {} };
    }
  }
  if (!store.themes || typeof store.themes !== "object") store.themes = {};
  const previous = store.themes[themeId];
  const now = Date.now();
  store._v = 1;
  store.themes[themeId] = {
    name: "Matugen",
    source: "vscode",
    definition,
    vscodeThemeSettingsId: "Matugen",
    createdAt: previous?.createdAt ?? now,
    updatedAt: now,
  };

  const slot = appearance === "light" ? "glass.theme.lightSettingsId" : "glass.theme.darkSettingsId";
  const otherSlot = appearance === "light" ? "glass.theme.darkSettingsId" : "glass.theme.lightSettingsId";
  const otherDefault = appearance === "light" ? "Cursor Dark" : "Cursor Light";

  const contrastSlot = appearance === "light"
    ? "glass.theme.lightHighContrastSettingsId"
    : "glass.theme.darkHighContrastSettingsId";

  put(db, themesKey, JSON.stringify(store));
  put(db, "glass.theme.settingsId", settingsId);
  put(db, "glass.theme.detectColorScheme", "false");
  put(db, "glass.theme.detectHighContrast", "false");
  put(db, "cursor.themeSync.enabled", "false");
  put(db, slot, settingsId);
  put(db, contrastSlot, settingsId);
  put(db, "glass.theme.highContrastSettingsId", settingsId);
  if (get(db, otherSlot) === settingsId) put(db, otherSlot, otherDefault);
  db.close();

  console.log(
    `cursor-glass-theme: Agents window set to Matugen (${appearance}, ${definition.pane})`,
  );
}

main();
