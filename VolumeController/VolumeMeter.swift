//
//  VolumeMeter.swift
//  VolumeController
//
//  Created by Bartosz S on 16/11/2024.
//

import Foundation
import CoreAudio
import AudioToolbox

class VolumeMeter {
    // Function to get the current output volume level (range 0.0 - 1.0)
    func getSystemVolume() -> Float? {
        guard let deviceID = getDefaultOutputDevice() else { return nil }
        
        var volume = Float(0.0)
        var propertySize = UInt32(MemoryLayout<Float>.size)
        
        // Get the volume for the left channel (channel 1)
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwareServiceDeviceProperty_VirtualMainVolume,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )
        
        let status = AudioObjectGetPropertyData(deviceID, &address, 0, nil, &propertySize, &volume)
        
        if status != noErr {
            print("Error getting volume: \(status)")
            return nil
        }
        
        return volume
    }

    // Function to set the system output volume (range 0.0 - 1.0)
    func setSystemVolume(_ level: Float) {
        guard let deviceID = getDefaultOutputDevice() else { return }
        
        var volume = level
        let propertySize = UInt32(MemoryLayout<Float>.size)
        
        // Set the volume for the left channel (channel 1)
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwareServiceDeviceProperty_VirtualMainVolume,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )
        
        let status = AudioObjectSetPropertyData(deviceID, &address, 0, nil, propertySize, &volume)
        
        if status != noErr {
            print("Error setting volume: \(status)")
        }
    }
    
    // Helper function to get the default output device
    private func getDefaultOutputDevice() -> AudioDeviceID? {
        var deviceID = AudioDeviceID(0)
        var propertySize = UInt32(MemoryLayout<AudioDeviceID>.size)
        
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        
        let status = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &propertySize, &deviceID)
        
        if status != noErr {
            print("Error getting default output device: \(status)")
            return nil
        }
        
        return deviceID
    }
}
