# Code

This is the hack's assembly roughly "ported" to JavaScript to make it easier to read and reason about.

## pseudo code

```javascript
const UNKNOWN = 0;
const INIT = 1;
const PLAYER_SELECT = 2;
const CPU_SELECT = 3;
const SCALE_DOWN = 4;
const DONE = 5;

let phase = UNKNOWN;
let playMode = 0;

function init() {
  playMode = 0;
  phase = INIT;

  renderImage(characterGrid, charGridSi);

  if (BIOS_PLAYER_MOD1 == 1) {
    playMode |= 1;

    renderImage(p1CursorLeft, p1CursorSi);
    renderImage(p1CursorRight, p1CursorSi + 1);
    // p1 cursor starts at Terry
    p1Data.cursorX = 0;
    p1Data.cursorY = 0;

    if (BIOS_PLAYER_MOD2 === 0) {
      // single player game
      renderImage(cpuCursorLeft, p2CursorSi);
      renderImage(cpuCursorRight, p2CursorSi + 1);
    }
  }

  if (BIOS_PLAYER_MOD2 === 1) {
    playMode |= 2;

    renderImage(p2CursorLeft, p2CursorSi);
    renderImage(p2CursorRight, p2CursorSi + 1);
    // p2 cursor starts at Clark
    p2Data.cursorX = 8;
    p2Data.cursorY = 0;

    if (BIOS_PLAYER_MOD1 === 0) {
      // single player game
      renderImage(cpuCursorLeft, p1CursorSi);
      renderImage(cpuCursorRight, p1CursorSi + 1);
    }
  }

  if (playMode === 0) {
    // demo mode, two cpu players
    renderImage(cpuCursorLeft, p1CursorSi);
    renderImage(cpuCursorRight, p1CursorSi + 1);
    renderImage(cpuCursorLeft, p2CursorSi);
    renderImage(cpuCursorRight, p2CursorSi + 1);
    phase = CPU_SELECT;
  }

  if (defeatedTeams === 0xff) {
    putRugalOnCharacterSelect();
  }
  if (playMode !== 0 && playMode !== 3) {
    // single player
    greyOutDefeatedTeams();
  }

  setCpuAlreadyUsedIndex();

  if ((playMode & 1) == 1) {
    if ((playMode & 2) == 0) {
      // single player mode, p1 side
      if ($108238 === 0x80) {
        // player one lost, and thus continued
        // add this fact to playMode
        playMode |= 0x20;
      }

      if ($108438 === 0x80) {
        // player two lost, so this is a subsequent
        // char select for a single player game, p1 side
        // add this fact to playMode so main can use it
        playMode |= 0x40;
        readyToExitCharSelect = true;
        p1Data.numChosenChars = 3;
      } else {
        // player two did not lose, this is the very first
        // char select for a single player game, p1 side
        readyToExitCharSelect = false;
        p1Data.numChosenChars = 0;
      }
    } else {
      // versus mode
      // have p1 pick their team, even if they won the last match
      readyToExitCharSelect = false;
      p1Data.numChosenChars = 0;
    }
  }

  if ((playMode & 2) == 1) {
    if ((playMode & 1) == 0) {
      // single player mode, p2 side
      if ($108438 === 0x80) {
        // player two lost, and thus continued
        // add this fact to playMode
        playMode |= 0x20;
      }

      if ($108238 === 0x80) {
        // player one lost, so this is a subsequent
        // char select for a single player game, p2 side
        // add this fact to playMode so main can use it
        playMode |= 0x40;
        readyToExitCharSelect = true;
        p2Data.numChosenChars = 3;
      } else {
        // player one did not lose, this is the very first
        // char select for a single player game, p1 side
        readyToExitCharSelect = false;
        p2Data.numChosenChars = 0;
      }
    } else {
      // versus mode
      // have p1 pick their team, even if they won the last match
      readyToExitCharSelect = false;
      p2Data.numChosenChars = 0;
    }
  }

  p1Data.fixedAddress = p1FocusedCharNameFixAddress;
  p1Data.charNameTableAddress = p1CharNameTableAddress;
  p2Data.fixedAddress = p2FocusedCharNameFixAddress;
  p2Data.charNameTableAddress = p2CharNameTableAddress;

  renderChosenAvatars();

  // is this a single player game, past the first round, and they
  // chose random select? If so, have char select re randomize
  if (playMode & 0x40) {
    if (playMode & 1 && p1ChoseRandomSelect) {
      p1Data.slotMachineCountdown = 36;
      p1Data.numChosenChars = p1Data.numNonRandomChars;
      p2Data.numChosenChars = 0;
    }

    if (playMode & 2 && p2ChoseRandomSelect) {
      p2Data.slotMachineCountdown = 36;
      p2Data.numChosenChars = p1Data.numNonRandomChars;
      p1Data.numChosenChars = 0;
    }
  }

  // now figure out what phase main should be at

  if (playMode === 0) {
    // demo mode
    phase = CPU_SELECT;
  }

  if (playMode === 3) {
    // versus mode
    phase = PLAYER_SELECT;
  }

  if (playMode & 0x40) {
    // subsequent match of a p1 game
    phase = CPU_SELECT;
  } else {
    phase = PLAYER_SELECT;
  }

  // put up the disclaimer strings
}

function main() {
  charSelectCounter += 1;

  if (playMode === 3) {
    // versus mode, give each player a random team
    // this accomplishes random background stages

    // just keep the bottom 3 bits, causing 0-7, which
    // is the team id range
    const curRandomTeamId = charSelectCounter & 0x7;
    $108231 = curRandomTeamId;
    $108431 = curRandomTeamId;
  }

  switch (phase) {
    case PLAYER_SELECT:
      runPlayerSelect();

      if (allCharactersSelected) {
        emptyTeamSelectTimer = true;
        phase = CPU_SELECT;
      }

      break;
    case CPU_SELECT:
      runCpuSelect();

      if (cpuDone) {
        phase = SCALE_DOWN;
      }

      break;
    case SCALE_DOWN:
      runScaleDown();

      if (scaleDownDone) {
        phase = DONE;
      }

      break;
  }
}
```
