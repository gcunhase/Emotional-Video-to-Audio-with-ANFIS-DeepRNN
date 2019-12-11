### How to Use
1. Extract sound features

2. Extract visual features

3. Train:
    * Settings:
        ```
        scripts/model/main_settings.m
        ```
    * ANFIS for emotion classification from HSL (visual features):
        ```
        scripts/mdoel/main_2DMOS_anfis.m
        ```
    * Seq2Seq for domain transformation from visual to audio features:
        ```
        scripts/mdoel/main_2DMOS_seq2seq.m
        ```
        > Options = [`rnn`, `lstm`]

	> [LSTM for Matlab](https://www.mathworks.com/help/deeplearning/ug/long-short-term-memory-networks.html), https://kr.mathworks.com/help/nnet/ref/nnet.cnn.layer.lstmlayer.html


4. Evaluation (music generation from visual features)
