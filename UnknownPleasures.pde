void setup() {
  // Set up graphics
  size(800, 800);
}

void draw() {
  // How many lines ("waves") are there in the final image (i.e. vertical count)
  int WAVE_COUNT = 80;

  // How many data points each wave has, horizontally
  int VALUES_PER_WAVE = 100;

  // The dimension (both width and height) of the drawing as a percentage of sketch width
  float DRAWING_DIMENSION = 0.50;

  // The height of each wave, as a percentage of pixel dimensions of the drawing (see the dimension
  // variable, below).
  float WAVE_HEIGHT = 0.17;

  // The width of the "middle part" of each wave
  float ENVELOPE_SPREAD = 0.20;

  // The noise coefficient to use when generating wave values.
  float NOISE_COEFFICIENT = 0.180;
  
  // Sketch background color
  color backgroundColor = color(10, 10, 10);
  
  // Wave color
  color strokeColor = color(240, 240, 240);

  // --------------------
  // --- DRAWING CODE ---
  // --------------------
  
  // Set up colors
  background(backgroundColor);
  stroke(strokeColor);
  
  // We're not using fills in this sketch, but it's here for good measure
  fill(backgroundColor);

  // Calculate pixel dimensions of the drawing (width and height are the same)
  float dimension = width * DRAWING_DIMENSION;

  // Reset the coordinate system origin to be at the top-left corner of the wave drawing
  translate(width / 2 - dimension / 2, height / 2 - dimension / 2);

  // Calculate the vertical pixel spacing of waves based on the number of waves and drawing pixel
  // dimensions
  float waveSpacing = dimension / WAVE_COUNT;

  // Calculate the pixel height of each wave
  float waveHeight = dimension * WAVE_HEIGHT;

  // Start drawing waves
  for (int i = 0; i < WAVE_COUNT; i++) {
    // Draw one wave
    drawWave(i, VALUES_PER_WAVE, dimension, waveHeight, ENVELOPE_SPREAD, NOISE_COEFFICIENT);

    // Move the coordinate system origin down, so that it's ready for the next wave
    translate(0, waveSpacing);
  }
}

void drawWave(int row, int valueCount, float widthPixels, float heightPixels, float spread,
              float noiseCoefficient) {
  // The distance between each curve point
  float horizontalSpacing = widthPixels / (valueCount - 1);

  // We're drawing each wave as a Processing shape
  beginShape();

  // Start drawing individual values within the wave
  for (int i = 1; i < valueCount; i++) {
    // The "envelope" is a common term denoting a function which is "wrapping" around another
    // function. In this case, the envelope is the gaussian ("bell") function, which is used to
    // scale the values of Processing's noise() function so that the middle part is more prominent.
    float envelope = gaussian(i, 1.0, valueCount / 2.0, spread * valueCount / 2);
    float value = envelope * noise(row, i * noiseCoefficient);

    // Define a new point in the shape we're currently drawing
    vertex(i * horizontalSpacing, - value * heightPixels);
  }

  // We're done drawing this wave
  endShape();
}

float gaussian(float x, float a, float b, float c) {
  // We're using the normalized Gaussian distribution as the envelope for each wave.
  // Read more about the function here: https://en.wikipedia.org/wiki/Gaussian_function
  float e = 2.7182818285;
  float exponent = -0.5 * pow((x - b) / c, 2);
  return a * pow(e, exponent);
}