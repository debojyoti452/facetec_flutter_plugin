//
// FaceTec Device SDK config file.
// Auto-generated via the FaceTec SDK Configuration Wizard
//
import UIKit
import Foundation
import FaceTecSDK

class Config {
    // -------------------------------------
    // REQUIRED
    // Available at https://dev.facetec.com/account
    // NOTE: This field is auto-populated by the FaceTec SDK Configuration Wizard.
    static let DeviceKeyIdentifier = "d0WNgqux0qh50fpaf3KrbBnZCZjT7R3K"

    // -------------------------------------
    // REQUIRED
    // The URL to call to process FaceTec SDK Sessions.
    // In Production, you likely will handle network requests elsewhere and without the use of this variable.
    // See https://dev.facetec.com/security-best-practices?link=facetec-server-rest-endpoint-security for more information.
    // NOTE: This field is auto-populated by the FaceTec SDK Configuration Wizard.
    static let BaseURL = "https://api.facetec.com/api/v3.1/biometrics"

    // -------------------------------------
    // REQUIRED
    // The FaceScan Encryption Key you define for your application.
    // Please see https://dev.facetec.com/facemap-encryption-keys for more information.
    // NOTE: This field is auto-populated by the FaceTec SDK Configuration Wizard.
    static let PublicFaceScanEncryptionKey =
        "-----BEGIN PUBLIC KEY-----\n" +
        "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5PxZ3DLj+zP6T6HFgzzk\n" +
        "M77LdzP3fojBoLasw7EfzvLMnJNUlyRb5m8e5QyyJxI+wRjsALHvFgLzGwxM8ehz\n" +
        "DqqBZed+f4w33GgQXFZOS4AOvyPbALgCYoLehigLAbbCNTkeY5RDcmmSI/sbp+s6\n" +
        "mAiAKKvCdIqe17bltZ/rfEoL3gPKEfLXeN549LTj3XBp0hvG4loQ6eC1E1tRzSkf\n" +
        "GJD4GIVvR+j12gXAaftj3ahfYxioBH7F7HQxzmWkwDyn3bqU54eaiB7f0ftsPpWM\n" +
        "ceUaqkL2DZUvgN0efEJjnWy5y1/Gkq5GGWCROI9XG/SwXJ30BbVUehTbVcD70+ZF\n" +
        "8QIDAQAB\n" +
        "-----END PUBLIC KEY-----"

    // -------------------------------------
    // Convenience method to initialize the FaceTec SDK.
    // NOTE: This function is auto-populated by the FaceTec SDK Configuration Wizard based on the Keys issued to your Apps.
    static func initializeFaceTecSDKFromAutogeneratedConfig(completion: @escaping (Bool)->()) {
        FaceTec.sdk.initializeInDevelopmentMode(deviceKeyIdentifier: Config.DeviceKeyIdentifier, faceScanEncryptionKey: Config.PublicFaceScanEncryptionKey, completion: { initializationSuccessful in
            completion(initializationSuccessful)
        })
    }
    
    // -------------------------------------
    // This app can modify the customization to demonstrate different look/feel preferences
    // NOTE: This function is auto-populated by the FaceTec SDK Configuration Wizard based on your UI Customizations you picked in the Configuration Wizard GUI.
    public static func retrieveConfigurationWizardCustomization() -> FaceTecCustomization {
        return FaceTecCustomization()
    }
    
    public static func retrieveLowLightConfigurationWizardCustomization() -> FaceTecCustomization {
        return FaceTecCustomization()
    }

    public static func retrieveDynamicDimmingConfigurationWizardCustomization() -> FaceTecCustomization {
        return FaceTecCustomization()
    }
    
    static var currentCustomization: FaceTecCustomization = retrieveConfigurationWizardCustomization()
    static var currentLowLightCustomization: FaceTecCustomization = retrieveLowLightConfigurationWizardCustomization()
    static var currentDynamicDimmingCustomization: FaceTecCustomization = retrieveDynamicDimmingConfigurationWizardCustomization()
    
    // -------------------------------------
    // Boolean to indicate the FaceTec SDK Configuration Wizard was used to generate this file.
    // In this Sample App, if this variable is true, a "Config Wizard Theme" will be added to this App's Design Showcase,
    // and choosing this option will set the FaceTec SDK UI/UX Customizations to the Customizations that you selected in the
    // Configuration Wizard.
    static let wasSDKConfiguredWithConfigWizard = false
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
