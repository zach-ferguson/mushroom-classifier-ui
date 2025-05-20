# mushroom_classifier_ui

This is a flutter app that interfaces with an image classifier model.

The app will take a user uploaded image of a fungus and predict whether the fungus is edible or poisonous.

The model was created with the [fastai library](https://www.fast.ai/) and trained with a fungus image dataset from [marcosvolpato](https://www.kaggle.com/datasets/marcosvolpato/edible-and-poisonous-fungi), so big shout out to him for making this dataset open and free to use.

- Jupyter notebook containing the code for creating/training the model: https://github.com/zach-ferguson/mushroom-classifier.
- Code for the FastAPI backend: https://huggingface.co/spaces/zferg1/mushroom-classifier-api/tree/main
