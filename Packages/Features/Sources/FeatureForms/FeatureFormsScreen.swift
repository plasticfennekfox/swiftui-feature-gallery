//
//  FeatureFormsScreen.swift
//  Features
//
//  Created by Fuchs on 4/11/25.
//

import SwiftUI
import AppCore
import DesignSystem

public struct FeatureFormsScreen: View {
    let container: AppContainer

    // MARK: - State

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var role: Role = .user

    @State private var notificationsEnabled: Bool = true
    @State private var newsletterEnabled: Bool = false
    @State private var age: Int = 25
    @State private var satisfaction: Double = 0.6
    @State private var selectedDate: Date = .now
    @State private var favoriteColor: Color = .blue

    @State private var bio: String = ""
    @State private var acceptTerms: Bool = false

    @State private var showSubmittedAlert: Bool = false
    @State private var validationMessage: String?

    @FocusState private var focusedField: Field?

    public init(container: AppContainer) {
        self.container = container
    }

    // MARK: - Body

    public var body: some View {
        FeatureScreen(
            title: NSLocalizedString("forms.title", comment: "Forms screen title")
        ) {
            // Account
            Card {
                Text("forms.section.account")
                    .font(.headline)

                TextField("forms.field.name", text: $name)
                    .textContentType(.name)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .name)
                    .onSubmit {
                        focusedField = .email
                    }

                TextField("forms.field.email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        focusedField = .password
                    }

                SecureField("forms.field.password", text: $password)
                    .textContentType(.password)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        focusedField = .bio
                    }

                Picker("forms.field.role", selection: $role) {
                    ForEach(Role.allCases) { role in
                        Text(role.title)
                            .tag(role)
                    }
                }
            }

            // Preferences
            Card {
                Text("forms.section.preferences")
                    .font(.headline)

                Toggle("forms.toggle.notifications", isOn: $notificationsEnabled)

                Toggle("forms.toggle.newsletter", isOn: $newsletterEnabled)

                Stepper(ageLabel, value: $age, in: 14...80)

                VStack(alignment: .leading) {
                    Text(satisfactionLabel)
                    Slider(value: $satisfaction, in: 0.0...1.0)
                }

                DatePicker(
                    "forms.field.reminderDate",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )

                ColorPicker(
                    "forms.field.favoriteColor",
                    selection: $favoriteColor,
                    supportsOpacity: false
                )
            }

            // About + terms
            Card {
                Text("forms.section.about")
                    .font(.headline)

                TextEditor(text: $bio)
                    .frame(minHeight: 80.0)
                    .focused($focusedField, equals: .bio)

                Toggle("forms.toggle.acceptTerms", isOn: $acceptTerms)

                if let validationMessage {
                    Text(validationMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }

            // Completion
            Card {
                Text("forms.progress.title")
                    .font(.headline)

                ProgressView(value: completionProgress)
                    .padding(.bottom, 4.0)

                Text(completionPercentageLabel)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            AppButton(
                NSLocalizedString("forms.submit", comment: "Submit form button title")
            ) {
                submit()
            }
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)
        }
        .alert(
            NSLocalizedString("forms.alert.submitted.title", comment: "Form submitted alert title"),
            isPresented: $showSubmittedAlert
        ) {
            Button(
                NSLocalizedString("forms.alert.submitted.ok", comment: "OK button title"),
                role: .cancel
            ) { }
        } message: {
            Text("forms.alert.submitted.message")
        }
    }

    // MARK: - Validation

    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@") &&
        password.count >= 4 &&
        acceptTerms
    }

    private var completionProgress: Double {
        var score: Double = 0.0
        if !name.isEmpty {
            score += 1.0
        }
        if !email.isEmpty {
            score += 1.0
        }
        if !password.isEmpty {
            score += 1.0
        }
        if !bio.isEmpty {
            score += 1.0
        }
        if acceptTerms {
            score += 1.0
        }
        return score / 5.0
    }

    private var ageLabel: String {
        String(
            format: NSLocalizedString("forms.age.label", comment: "Age label with value"),
            age
        )
    }

    private var satisfactionLabel: String {
        let percent: Int = Int(satisfaction * 100.0)
        return String(
            format: NSLocalizedString("forms.slider.satisfaction", comment: "Satisfaction label with percent"),
            percent
        )
    }

    private var completionPercentageLabel: String {
        let percent: Int = Int(completionProgress * 100.0)
        return String(
            format: NSLocalizedString("forms.progress.text", comment: "Completion percent text"),
            percent
        )
    }

    private func submit() {
        guard isFormValid else {
            validationMessage = NSLocalizedString(
                "forms.validation.error",
                comment: "Validation error message for form"
            )
            return
        }

        validationMessage = nil

        container.analytics.track(
            "forms.submit",
            params: [
                "name": name,
                "email": email,
                "role": role.rawValue,
                "notifications": String(notificationsEnabled)
            ]
        )
        container.logger.log("Form submitted", category: "forms")

        showSubmittedAlert = true
    }

    // MARK: - Types

    private enum Field {
        case name
        case email
        case password
        case bio
    }

    public enum Role: String, CaseIterable, Identifiable {
        case user
        case admin
        case guest

        public var id: String {
            rawValue
        }

        public var title: String {
            switch self {
            case .user:
                return NSLocalizedString("forms.role.user", comment: "User role title")
            case .admin:
                return NSLocalizedString("forms.role.admin", comment: "Admin role title")
            case .guest:
                return NSLocalizedString("forms.role.guest", comment: "Guest role title")
            }
        }
    }
}

