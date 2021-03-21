import AVFoundation
import XCTest

@testable import Opus

final class OpusTests: XCTestCase {
	func testMemorySizes() {
		// These are implementation independent, and may change:
		XCTAssertEqual(opus_decoder_get_size(1), 18228)
		XCTAssertEqual(opus_decoder_get_size(2), 26996)
	}

	func testErrorValues() {
		XCTAssertEqual(Opus.Error.ok.rawValue, OPUS_OK)
		XCTAssertEqual(Opus.Error.badArg.rawValue, OPUS_BAD_ARG)
		XCTAssertEqual(Opus.Error.bufferTooSmall.rawValue, OPUS_BUFFER_TOO_SMALL)
		XCTAssertEqual(Opus.Error.internalError.rawValue, OPUS_INTERNAL_ERROR)
		XCTAssertEqual(Opus.Error.invalidPacket.rawValue, OPUS_INVALID_PACKET)
		XCTAssertEqual(Opus.Error.unimplemented.rawValue, OPUS_UNIMPLEMENTED)
		XCTAssertEqual(Opus.Error.invalidState.rawValue, OPUS_INVALID_STATE)
		XCTAssertEqual(Opus.Error.allocFail.rawValue, OPUS_ALLOC_FAIL)
	}

	func testApplicationValues() {
		XCTAssertEqual(Opus.Application.audio.rawValue, OPUS_APPLICATION_AUDIO)
		XCTAssertEqual(Opus.Application.voip.rawValue, OPUS_APPLICATION_VOIP)
		XCTAssertEqual(Opus.Application.restrictedLowDelay.rawValue, OPUS_APPLICATION_RESTRICTED_LOWDELAY)
	}

	static let commonFormatInt16Mono = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 1, interleaved: true)!
	static let commonFormatInt16Stereo = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 2, interleaved: true)!
	static let commonFormatInt16StereoNonInterleaved = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 2, interleaved: false)!
	static let commonFormatInt32Mono = AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: 48000, channels: 1, interleaved: true)!
	static let commonFormatInt32Stereo = AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: 48000, channels: 2, interleaved: true)!
	static let commonFormatFloat32Mono = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 1, interleaved: true)!
	static let commonFormatFloat32Stereo = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 2, interleaved: true)!
	static let commonFormatFloat64Mono = AVAudioFormat(commonFormat: .pcmFormatFloat64, sampleRate: 48000, channels: 1, interleaved: true)!
	static let commonFormatFloat64Stereo = AVAudioFormat(commonFormat: .pcmFormatFloat64, sampleRate: 48000, channels: 2, interleaved: true)!

	static let formatInt16Mono = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1, AVLinearPCMIsNonInterleaved: false])!
	static let formatInt16Stereo = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: false])!
	static let formatInt16StereoNonInterleaved = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: true])!
	static let formatInt32Mono = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 32, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1, AVLinearPCMIsNonInterleaved: false])!
	static let formatInt32Stereo = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 32, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: false])!
	static let formatFloat32Mono = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: true, AVLinearPCMBitDepthKey: 32, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1, AVLinearPCMIsNonInterleaved: false])!
	static let formatFloat32Stereo = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: true, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: false])!

	static let formatOpusMono = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatOpus, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1])!
	static let formatOpusStereo = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatOpus, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2])!

	static let validFormats = [
		commonFormatInt16Mono,
		commonFormatInt16Stereo,
		commonFormatFloat32Mono,
		commonFormatFloat32Stereo,
		formatInt16Mono,
		formatInt16Stereo,
		formatFloat32Mono,
		formatFloat32Stereo,
	]

	static let invalidFormats = [
		commonFormatInt16StereoNonInterleaved,
		commonFormatInt32Mono,
		commonFormatInt32Stereo,
		commonFormatFloat64Mono,
		commonFormatFloat64Stereo,
		formatInt16StereoNonInterleaved,
		formatInt32Mono,
		formatInt32Stereo,
		formatOpusMono,
		formatOpusStereo,
	]

	func testIsValidFormat() throws {
		Self.validFormats.forEach {
			XCTAssert(Opus.isValidFormat($0), $0.description)
		}

		Self.invalidFormats.forEach {
			XCTAssertFalse(Opus.isValidFormat($0), $0.description)
		}
	}
}
