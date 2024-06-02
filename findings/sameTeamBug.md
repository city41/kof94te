# Same team bug

Sometimes with cpu custom teams, the game won't pick a new team for the next round, just stick with the previous team.

- It does require human random select
- It might require AES mode

- It can happen in team or single play
- When this happens, there is no cpu cursor shown
- the trap was hit, so cpu custom team routine never runs to cause the symptom
- increasing the time of human random select between rounds makes it happen more often

  - increasing it too much causes the game to lock up

- this happens when the $CPU_RANDOM_SELECT_COUNTER_FOR_PX hits $ff before human random select is finished.
  - it will exit char select, never give cpu random select a chance to run, and thus uses the same team as last round
  - CPU_RANDOM_SELECT_COUNTER_FOR_PX does vary a bit depending on which original 8 team was randomly chosen
