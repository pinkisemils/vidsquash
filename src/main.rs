use std::env;

use rsmpeg::{
    avcodec::{AVCodec, AVCodecContext, AVCodecParserContext, AVPacket},
    avutil::AVFrame,
    error::RsmpegError,
    ffi,
};
use std::{fs, io::prelude::*, slice};

fn main() {
    let path = env::args().skip(1).next().expect("epxected path to file");

    let decoder = AVCodec::find_decoder(ffi::AVCodecID_AV_CODEC_ID_MPEG1VIDEO).unwrap();
    let decode_context = AVCodecContext::new(&decoder);

    println!("Hello, world!");
}
