# MelodyLang Compiler

MelodyLang is a small music programming language implemented in the Jupyter notebook `MelodyLang_Compiler.ipynb`.

You write simple text instructions such as:

```text
tempo 100
instrument piano

note C4 quarter
note E4 quarter
note G4 quarter
```

The compiler reads this text and creates a MIDI file that can be opened in a MIDI player, MuseScore, VLC, or an online MIDI player.

## Project Files

| File                        | Purpose                                |
| --------------------------- | -------------------------------------- |
| `MelodyLang_Compiler.ipynb` | The compiler, examples, and test cases |
| `test_1_30sec_piano.mid`    | MIDI output from the piano test        |
| `test_2_30sec_flute.mid`    | MIDI output from the flute test        |
| `flow`                      | A short pipeline outline               |
| `README.md`                 | This documentation                     |

## 1. Music Basics

You do not need a musical background to use MelodyLang. This section explains the terms used by the language.

### Sound and Music

A musical program describes sounds in time. Each sound has several important properties:

- Which pitch should be played
- How long it should be played
- When it should start
- How fast the music should move
- Which instrument should play it

The compiler converts these properties into MIDI data.

### Note

A note is one musical sound with a particular pitch and duration.

Example:

```text
note C4 quarter
```

This means:

- Play the pitch `C4`
- Keep it playing for a quarter-note duration

### Pitch

Pitch describes how high or low a sound is.

MelodyLang writes a pitch using a letter and an octave number:

```text
C4
D4
E4
A5
```

The letters are:

```text
A B C D E F G
```

The number is the octave. A higher octave generally sounds higher.

For example, `C5` is higher than `C4`.

### Sharp and Flat

A sharp raises a pitch slightly:

```text
F#4
```

A flat lowers a pitch slightly:

```text
Bb4
```

MelodyLang accepts an optional `#` or `b` in a pitch.

Valid examples:

```text
C4
F#3
Bb5
```

### MIDI Pitch Numbers

MIDI internally represents pitches as numbers instead of names.

Common examples are:

| MelodyLang pitch | MIDI number |
| ---------------- | ----------: |
| `C4`             |          60 |
| `D4`             |          62 |
| `E4`             |          64 |
| `F4`             |          65 |
| `G4`             |          67 |
| `A4`             |          69 |
| `B4`             |          71 |

The function `pitch_to_midi()` performs this conversion.

### Duration

Duration means how long a note lasts.

MelodyLang supports these durations:

| Duration    | Beats | Simple meaning       |
| ----------- | ----: | -------------------- |
| `whole`     |     4 | Long note            |
| `half`      |     2 | Half of a whole note |
| `quarter`   |     1 | One beat             |
| `eighth`    |   0.5 | Half a beat          |
| `sixteenth` |  0.25 | A quarter of a beat  |

Examples:

```text
note C4 whole
note D4 half
note E4 quarter
note F4 eighth
```

The compiler stores durations as numbers of beats:

```python
"whole": 4.0
"half": 2.0
"quarter": 1.0
"eighth": 0.5
"sixteenth": 0.25
```

### Beat

A beat is a unit of musical time. It is similar to counting:

```text
1, 2, 3, 4
```

A quarter note takes one beat in this compiler. Two quarter notes take two beats.

### Tempo and BPM

Tempo controls the speed of the music.

BPM means **beats per minute**.

```text
tempo 100
```

means the music plays at 100 beats per minute.

The duration formula is:

```text
time in seconds = total beats / BPM * 60
```

For the piano test:

```text
50 beats / 100 BPM * 60 = 30 seconds
```

The compiler accepts tempos from 20 to 300 BPM.

### Rest

A rest is silence. It advances the timeline without playing a note.

```text
rest quarter
```

This creates one beat of silence.

### Chord

A chord is several pitches played at the same time.

```text
chord [C4, E4, G4] quarter
```

This plays `C4`, `E4`, and `G4` together for one beat.

A normal note contains one pitch. A chord contains a list of pitches.

### Instrument

An instrument selects the MIDI sound used to play the notes.

Examples:

```text
instrument piano
instrument flute
instrument violin
instrument guitar
```

The compiler maps instrument names to General MIDI program numbers. For example:

```python
"piano": 0
"violin": 40
"flute": 73
```

The MIDI player decides which actual sound to use for the selected instrument.

### Repeat

A repeat runs a group of statements multiple times.

```text
repeat 5 {
    note C4 quarter
    note E4 quarter
}
```

The body contains two beats. Repeating it five times creates ten beats.

Repeats make it possible to create a longer tune without manually writing the same notes many times.

### MIDI Is Not an Audio File

A MIDI file does not contain recorded sound like an MP3 or WAV file.

It contains instructions such as:

- Play MIDI pitch 60
- Start at beat 4
- Continue for 1 beat
- Use instrument piano
- Use velocity 100

A MIDI player interprets those instructions and produces sound.

## 2. MelodyLang Syntax

### Tempo

```text
tempo <BPM>
```

Example:

```text
tempo 120
```

### Instrument

```text
instrument <name>
```

Example:

```text
instrument piano
```

### Note

```text
note <pitch> <duration>
```

Example:

```text
note C4 quarter
```

### Chord

```text
chord [<pitch>, <pitch>, ...] <duration>
```

Example:

```text
chord [C4, E4, G4] whole
```

### Rest

```text
rest <duration>
```

Example:

```text
rest half
```

### Repeat

```text
repeat <number> {
    <statements>
}
```

Example:

```text
repeat 4 {
    note C4 eighth
    note D4 eighth
}
```

## 3. Compiler Pipeline

The compiler uses these stages:

```text
MelodyLang source text
        |
        v
Lexer
        |
        v
Tokens
        |
        v
Parser
        |
        v
AST
        |
        v
Semantic Analyzer
        |
        v
Pattern Compressor
        |
        v
Music IR
        |
        v
IR Optimizer
        |
        v
MIDI Code Generator
        |
        v
.mid file
```

## 4. Lexer and Tokens

The lexer is the first compiler stage. It reads characters and groups them into tokens.

A token is a meaningful unit of source code.

For this input:

```text
note C4 quarter
```

the lexer produces approximately:

```text
IDENT("note")
IDENT("C4")
IDENT("quarter")
EOF
```

The compiler defines tokens using:

```python
@dataclass
class Token:
    type: str
    value: str
    line: int
```

For example:

```python
Token(type="IDENT", value="C4", line=1)
```

means that `C4` is an identifier found on line 1.

### Lexer Token Types

| Token type | Example                 | Purpose                            |
| ---------- | ----------------------- | ---------------------------------- |
| `SKIP`     | spaces and new lines    | Ignored formatting                 |
| `COMMENT`  | `// comment`            | Ignored comment                    |
| `LBRACE`   | `{`                     | Opens a repeat block               |
| `RBRACE`   | `}`                     | Closes a repeat block              |
| `LBRACKET` | `[`                     | Opens a chord list                 |
| `RBRACKET` | `]`                     | Closes a chord list                |
| `COMMA`    | `,`                     | Separates chord pitches            |
| `INT`      | `100`, `5`              | Integer numbers                    |
| `IDENT`    | `note`, `C4`, `quarter` | Words, pitches, and durations      |
| `EOF`      | End of input            | Tells the parser input is finished |

The lexer does not decide whether a note is valid. It only recognizes text pieces. Validation happens later.

## 5. Parser and AST

The parser receives tokens and checks whether they follow the MelodyLang grammar.

For example, a note must have this structure:

```text
note <pitch> <duration>
```

The parser converts it into an AST node:

```python
NoteNode(
    pitch="C4",
    duration="quarter",
    line=1,
)
```

The AST classes are:

```python
TempoNode
InstrumentNode
NoteNode
ChordNode
RestNode
RepeatNode
```

For this program:

```text
tempo 100
instrument piano
note C4 quarter
chord [E4, G4, B4] half
rest eighth
```

the AST is conceptually:

```text
Program
├── TempoNode(100)
├── InstrumentNode("piano")
├── NoteNode("C4", "quarter")
├── ChordNode(["E4", "G4", "B4"], "half")
└── RestNode("eighth")
```

The AST removes unnecessary text details and stores the actual meaning of each statement.

## 6. Semantic Analyzer

The parser checks structure. The semantic analyzer checks meaning.

These two programs have different problems:

```text
note C4
```

This has invalid structure because the duration is missing.

```text
tempo 500
```

This has valid structure but an invalid value because 500 BPM is outside the allowed range.

The semantic analyzer validates:

- Tempo range: 20 to 300 BPM
- Octave range: 0 to 8
- Pitch format
- Duration names
- Instrument names
- Repeat count: 1 to 1000
- Chord contents

If semantic errors are found, the compiler raises `MelodyLangSemanticError`.

## 7. Pattern Compressor

The pattern compressor looks for repeated statements and can represent them as a `RepeatNode`.

For example, this sequence:

```text
note C4 quarter
note E4 quarter
note C4 quarter
note E4 quarter
```

can be represented internally as:

```text
repeat 2 {
    note C4 quarter
    note E4 quarter
}
```

The current 30-second tests already contain explicit repeat blocks, so their `pattern_folds_applied` value is zero. The repeat blocks are still expanded later when the musical timeline is generated.

## 8. Music IR

IR means **Intermediate Representation**.

It is a simpler form of the program that describes a timeline of musical events.

The compiler uses:

```python
@dataclass
class MusicEvent:
    kind: str
    start_beat: float
    duration_beats: float
    pitches: List[int]
    velocity: int = 100
```

A note event contains:

- `kind`: `note`
- `start_beat`: when it starts
- `duration_beats`: how long it lasts
- `pitches`: MIDI pitch numbers
- `velocity`: loudness value

A rest event contains:

- `kind`: `rest`
- A start time
- A duration
- No pitches

The IR generator uses a cursor to track the current beat:

```python
self.cursor = 0.0
```

For this input:

```text
note C4 quarter
note E4 quarter
note G4 half
```

the timeline is:

| Event | Start beat | Duration |
| ----- | ---------: | -------: |
| `C4`  |          0 |   1 beat |
| `E4`  |          1 |   1 beat |
| `G4`  |          2 |  2 beats |

## 9. IR Optimizer

The optimizer simplifies the event list.

It merges adjacent rests:

```text
rest quarter
rest quarter
```

into one longer rest.

It also merges adjacent identical notes:

```text
note C4 quarter
note C4 quarter
```

into one note lasting two beats.

The compiler reports:

```text
events_before
events_after
events_merged
```

The current test melodies use varied notes, so no events are merged.

## 10. MIDI Code Generator

The code generator uses the `midiutil` package to create the `.mid` file.

It creates one MIDI track, adds the tempo and instrument, and then writes every note event.

Conceptually, this call:

```python
midi.addNote(0, 0, 60, 0.0, 1.0, 100)
```

means:

- Track 0
- MIDI channel 0
- Pitch 60, which is C4
- Start at beat 0
- Play for 1 beat
- Velocity 100

A chord writes several pitches at the same start beat.

A rest does not require a MIDI note event. The next note simply starts later in the timeline.

The file is saved with:

```python
with open(output_path, "wb") as f:
    midi.writeFile(f)
```

## 11. The Four Test Cases

### Test 1: Valid Piano Tune

```text
tempo 100
instrument piano
repeat 5 {
    note C4 quarter
    note E4 quarter
    note G4 quarter
    note C5 quarter
    chord [C4, E4, G4] quarter
    note B4 quarter
    note A4 quarter
    note G4 quarter
    note E4 quarter
    note D4 quarter
}
```

The motif has 10 beats and repeats 5 times:

```text
10 * 5 = 50 beats
50 / 100 * 60 = 30 seconds
```

Output:

```text
test_1_30sec_piano.mid
```

### Test 2: Valid Flute Tune

```text
tempo 90
instrument flute
repeat 5 {
    note D4 quarter
    note E4 quarter
    note F4 quarter
    note G4 quarter
    note A4 quarter
    note G4 quarter
    chord [D4, F4, A4] quarter
    chord [E4, G4, B4] quarter
    note D5 quarter
}
```

The motif has 9 beats and repeats 5 times:

```text
9 * 5 = 45 beats
45 / 90 * 60 = 30 seconds
```

Output:

```text
test_2_30sec_flute.mid
```

### Test 3: Invalid Syntax

```text
tempo 120
instrument piano
note C4
```

The duration is missing. The parser expects:

```text
note <pitch> <duration>
```

Expected result:

```text
EXPECTED SYNTAX ERROR:
Line 4: expected IDENT but found EOF
```

This test does not create a MIDI file.

### Test 4: Invalid Semantics

```text
tempo 500
instrument violin
note D4 quarter
```

The structure is correct, but the tempo is invalid because the maximum allowed tempo is 300 BPM.

Expected result:

```text
EXPECTED SEMANTIC ERROR:
Line 1: tempo 500 out of range
```

This test does not create a MIDI file.

## 12. How to Run the Notebook on Windows

Open `MelodyLang_Compiler.ipynb` in VS Code.

Install the VS Code extensions:

- Python
- Jupyter

Select a Python kernel. Then run the cells in this order:

1. Package installation cell
2. Compiler-definition cell
3. The sample compiler cell, if you want to test the original sample
4. The two 30-second valid test cells
5. The syntax-error test cell
6. The semantic-error test cell

The most important cells are:

- The package installation cell installs `midiutil` and `pretty_midi`
- The compiler-definition cell defines all compiler classes
- The valid test cells generate MIDI files
- The invalid test cells demonstrate compiler errors

You can also use **Run All** after selecting the Python kernel.

## 13. Windows Audio Note

The compiler generates MIDI files on Windows.

The optional audio preview uses FluidSynth and a Linux soundfont path. That audio preview is not automatically available on Windows.

This does not affect MIDI generation. To listen to the output, open the generated `.mid` file with:

- MuseScore
- VLC
- An online MIDI player
- Another MIDI-compatible music application

## 14. Summary

This project demonstrates the main stages of compiler design:

1. The lexer turns characters into tokens.
2. The parser turns tokens into an AST.
3. The semantic analyzer checks whether values are valid.
4. The pattern compressor simplifies repeated structures.
5. The IR generator creates a timeline of music events.
6. The IR optimizer combines unnecessary adjacent events.
7. The code generator converts the timeline into MIDI data.
8. A MIDI player converts the MIDI instructions into audible music.

The notebook is therefore both a compiler-design demonstration and a working music-generation program.
