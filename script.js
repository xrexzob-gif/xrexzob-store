const input = document.getElementById("audioInput");
const upload = document.getElementById("dropZone");

const fileCard = document.getElementById("fileCard");
const fileName = document.getElementById("fileName");
const fileInfo = document.getElementById("fileInfo");
const removeFile = document.getElementById("removeFile");

const preview = document.getElementById("preview");
const player = document.getElementById("player");
const duration = document.getElementById("duration");

const processButton = document.getElementById("process");

const speedValue = document.getElementById("speedValue");
const speedButtons = document.querySelectorAll(".speed[data-speed]");
const customButton = document.getElementById("custom");

const progressBar = document.getElementById("bar");
const progressPercent = document.getElementById("percent");
const status = document.getElementById("status");
const state = document.getElementById("state");

let currentFile = null;
let multiplier = 1;


/* =========================
   LOADING
========================= */

window.addEventListener("load", () => {

  setTimeout(() => {

    document
      .getElementById("loader")
      .classList.add("hide");

  }, 1700);

});


/* =========================
   FILE PICKER
========================= */

input.addEventListener("change", () => {

  if (input.files.length) {
    loadFile(input.files[0]);
  }

});


/* =========================
   DRAG DROP
========================= */

["dragenter","dragover"].forEach(event => {

  upload.addEventListener(event, e => {

    e.preventDefault();
    upload.classList.add("drag");

  });

});

["dragleave","drop"].forEach(event => {

  upload.addEventListener(event, e => {

    e.preventDefault();
    upload.classList.remove("drag");

  });

});

upload.addEventListener("drop", e => {

  const file = e.dataTransfer.files[0];

  if (file) {
    loadFile(file);
  }

});


/* =========================
   LOAD FILE
========================= */

function loadFile(file){

  const ext =
    file.name
      .split(".")
      .pop()
      .toLowerCase();

  if(ext !== "mp3" && ext !== "wav"){

    alert("Pilih file MP3 atau WAV.");

    return;
  }

  currentFile = file;

  fileName.textContent = file.name;

  fileInfo.textContent =
    `${formatBytes(file.size)} • ${ext.toUpperCase()}`;

  fileCard.classList.remove("hidden");
  preview.classList.remove("hidden");

  processButton.disabled = false;

  status.textContent = "Audio loaded";
  state.textContent = "READY";

  setProgress(0);

  const url = URL.createObjectURL(file);

  player.src = url;

  player.onloadedmetadata = () => {

    duration.textContent =
      formatTime(player.duration);

  };

}


/* =========================
   REMOVE
========================= */

removeFile.addEventListener("click", () => {

  currentFile = null;

  input.value = "";

  fileCard.classList.add("hidden");
  preview.classList.add("hidden");

  player.pause();
  player.removeAttribute("src");
  player.load();

  processButton.disabled = true;

  status.textContent = "Waiting for audio...";
  state.textContent = "READY";

  setProgress(0);

});


/* =========================
   SPEED PRESETS
========================= */

speedButtons.forEach(button => {

  button.addEventListener("click", () => {

    speedButtons.forEach(x =>
      x.classList.remove("active")
    );

    customButton.classList.remove("active");

    button.classList.add("active");

    multiplier =
      Number(button.dataset.speed);

    speedValue.textContent =
      multiplier.toFixed(2) + "x";

    status.textContent =
      `Speed ${multiplier.toFixed(2)}x selected`;

  });

});


/* =========================
   CUSTOM
========================= */

customButton.addEventListener("click", () => {

  const answer = prompt(
    "Masukkan multiplier custom:",
    multiplier.toFixed(2)
  );

  if(answer === null) return;

  const value = Number(answer);

  if(
    !Number.isFinite(value) ||
    value <= 0 ||
    value > 10
  ){

    alert("Masukkan angka antara 0.01 sampai 10.");

    return;
  }

  speedButtons.forEach(x =>
    x.classList.remove("active")
  );

  customButton.classList.add("active");

  multiplier = value;

  speedValue.textContent =
    value.toFixed(2) + "x";

  status.textContent =
    `Custom speed ${value.toFixed(2)}x`;

});


/* =========================
   PROCESS
========================= */

processButton.addEventListener("click", async () => {

  if(!currentFile){

    alert("Upload audio terlebih dahulu.");

    return;
  }

  processButton.disabled = true;

  try{

    await processAudio();

  }catch(error){

    console.error(error);

    state.textContent = "ERROR";
    status.textContent = "Processing failed";

    alert(
      "Audio gagal diproses.\n\n" +
      error.message
    );

  }

  processButton.disabled = false;

});


/* =========================
   AUDIO ENGINE
========================= */

async function processAudio(){

  setProgress(5);

  state.textContent = "LOADING";
  status.textContent = "Reading audio...";

  const data =
    await currentFile.arrayBuffer();

  setProgress(15);

  status.textContent =
    "Decoding audio...";

  const AudioContext =
    window.AudioContext ||
    window.webkitAudioContext;

  if(!AudioContext){

    throw new Error(
      "Browser tidak mendukung Web Audio API."
    );
  }

  const ctx =
    new AudioContext();

  let decoded;

  try{

    decoded =
      await ctx.decodeAudioData(
        data.slice(0)
      );

  }finally{

    await ctx.close();

  }

  setProgress(30);

  state.textContent = "PROCESSING";
  status.textContent =
    `Rendering ${multiplier.toFixed(2)}x...`;

  const outputLength =
    Math.max(
      1,
      Math.ceil(
        decoded.length / multiplier
      )
    );

  const offline =
    new OfflineAudioContext(
      decoded.numberOfChannels,
      outputLength,
      decoded.sampleRate
    );

  const source =
    offline.createBufferSource();

  source.buffer = decoded;

  source.playbackRate.value =
    multiplier;

  source.connect(
    offline.destination
  );

  source.start(0);

  setProgress(45);

  const rendered =
    await offline.startRendering();

  setProgress(75);

  status.textContent =
    "Encoding WAV...";

  const wav =
    encodeWav(rendered);

  setProgress(90);

  status.textContent =
    "Preparing download...";

  const base =
    currentFile.name
      .replace(/\.[^/.]+$/, "");

  const speed =
    multiplier
      .toFixed(2)
      .replace(".", "_");

  const filename =
    `${base}_xrexzob_${speed}x.wav`;

  download(wav, filename);

  setProgress(100);

  state.textContent = "COMPLETE";
  status.textContent =
    "Download started successfully";

}


/* =========================
   WAV ENCODER
========================= */

function encodeWav(audio){

  const channels =
    audio.numberOfChannels;

  const sampleRate =
    audio.sampleRate;

  const samples =
    audio.length;

  const bits = 16;

  const blockAlign =
    channels * bits / 8;

  const byteRate =
    sampleRate * blockAlign;

  const dataSize =
    samples * blockAlign;

  const buffer =
    new ArrayBuffer(
      44 + dataSize
    );

  const view =
    new DataView(buffer);


  writeString(view,0,"RIFF");

  view.setUint32(
    4,
    36 + dataSize,
    true
  );

  writeString(view,8,"WAVE");

  writeString(view,12,"fmt ");

  view.setUint32(
    16,
    16,
    true
  );

  view.setUint16(
    20,
    1,
    true
  );

  view.setUint16(
    22,
    channels,
    true
  );

  view.setUint32(
    24,
    sampleRate,
    true
  );

  view.setUint32(
    28,
    byteRate,
    true
  );

  view.setUint16(
    32,
    blockAlign,
    true
  );

  view.setUint16(
    34,
    bits,
    true
  );

  writeString(view,36,"data");

  view.setUint32(
    40,
    dataSize,
    true
  );


  const channelData = [];

  for(let c = 0; c < channels; c++){

    channelData.push(
      audio.getChannelData(c)
    );

  }


  let offset = 44;

  for(let i = 0; i < samples; i++){

    for(let c = 0; c < channels; c++){

      let sample =
        channelData[c][i];

      sample =
        Math.max(
          -1,
          Math.min(1,sample)
        );

      const value =
        sample < 0
          ? sample * 32768
          : sample * 32767;

      view.setInt16(
        offset,
        value,
        true
      );

      offset += 2;

    }

  }

  return new Blob(
    [buffer],
    {type:"audio/wav"}
  );

}


/* =========================
   HELPERS
========================= */

function writeString(view,offset,string){

  for(let i=0;i<string.length;i++){

    view.setUint8(
      offset+i,
      string.charCodeAt(i)
    );

  }

}


function download(blob,name){

  const url =
    URL.createObjectURL(blob);

  const link =
    document.createElement("a");

  link.href = url;
  link.download = name;

  document.body.appendChild(link);

  link.click();

  link.remove();

  setTimeout(() => {

    URL.revokeObjectURL(url);

  },2000);

}


function setProgress(value){

  value =
    Math.max(
      0,
      Math.min(100,value)
    );

  progressBar.style.width =
    value + "%";

  progressPercent.textContent =
    Math.round(value) + "%";

}


function formatBytes(bytes){

  if(bytes === 0)
    return "0 Bytes";

  const units =
    ["Bytes","KB","MB","GB"];

  const index =
    Math.floor(
      Math.log(bytes) /
      Math.log(1024)
    );

  return (
    (bytes /
      Math.pow(1024,index))
      .toFixed(2)
    + " "
    + units[index]
  );

}


function formatTime(seconds){

  if(!Number.isFinite(seconds))
    return "00:00";

  const min =
    Math.floor(seconds / 60);

  const sec =
    Math.floor(seconds % 60);

  return (
    String(min).padStart(2,"0")
    + ":" +
    String(sec).padStart(2,"0")
  );

}
