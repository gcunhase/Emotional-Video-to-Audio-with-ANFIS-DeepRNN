## About
Emotional Music Generation with ANFIS-LSTM

### Contents
[Requirements](#requirements) • [Dataset](#dataset) • [How to Use](#how-to-use) • [How to Cite](#acknowledgement) 

## Requirements
Matlab 2017, Mac OS

Toolboxes: Fuzzy Logic, Deep Learning

## Dataset
### Lindsey Stirling Dataset
* 8 music videos
* Video format: `mp4`
* Emotion labels:
    * MOS: 2D-axis (Valence and Arousal)
    * file: `dataset/Target - 2D emotion scores.tsv`

### DEAP


## Model
* Extract audio and visual features
* ANFIS for emotion classification of visual features
* Seq2Seq for audio feature generation (multi-modal domain transformation)
* Mapping of audio features to audio snippets for music generation

### How to Use
> All the codes are for the first dataset (Lindsey). The codes corresponding to the DEAP are also available.

0. Change current folder to where this file is located

1. Download datasets

2. Extract audio and visual features
    * Extract sound features: ```scripts/emotion_from_sound/main_sound2feat_lindsey.m```
    * Extract visual features: ```scripts/emotion_from_visual/.m```

3. Train:
    * Settings and Load data:
        ```
        scripts/model/main_settings.m
        ```
    * ANFIS for emotion classification from HSL (visual features):
        ```
        scripts/model/main_anfis.m
        ```
    * Seq2Seq for domain transformation from visual to audio features:
        ```
        scripts/model/main_seq2seq_train.m
        ```
        > Options = [`rnn`, `lstm`]

	> [LSTM for Matlab](https://www.mathworks.com/help/deeplearning/ug/long-short-term-memory-networks.html), https://kr.mathworks.com/help/nnet/ref/nnet.cnn.layer.lstmlayer.html


4. Evaluation (music generation from visual features)

## Acknowledgement
In case you wish to use this code, please use the following citation:



Contact: `gwena.cs@gmail.com`


