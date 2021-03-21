import AVFoundation
import Copus

public extension Opus {
	class Decoder {
		let format: AVAudioFormat
		let decoder: OpaquePointer

		// TODO: throw an error if format is unsupported
		public init(format: AVAudioFormat, application _: Application = .audio) throws {
			if !Opus.isValidFormat(format) {
				throw Opus.Error.badArg
			}

			self.format = format

			// Initialize Opus decoder
			var error: Opus.Error = .ok
			decoder = opus_decoder_create(Int32(format.sampleRate), Int32(format.channelCount), &error.rawValue)
			if error != .ok {
				throw error
			}
		}

		deinit {
			opus_decoder_destroy(decoder)
		}

		public func reset() throws {
			let error = Opus.Error(opus_decoder_init(decoder, Int32(format.sampleRate), Int32(format.channelCount)))
			if error != .ok {
				throw error
			}
		}

		public func decode(_ input: Data) throws -> AVAudioPCMBuffer {
			let bytes = [UInt8](input)
			let sampleCount = opus_decoder_get_nb_samples(decoder, bytes, Int32(bytes.count))
			let output = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(sampleCount))!
			let decodedCount = opus_decode_float(decoder, bytes, Int32(bytes.count), output.floatChannelData![0], Int32(output.frameCapacity), 0)
			if decodedCount < 0 {
				throw Opus.Error(decodedCount)
			}
			output.frameLength = AVAudioFrameCount(decodedCount)
			return output
		}
	}
}