pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string endpoint: "http://" + serverIp + ":" + serverPort + "/v1/chat/completions"
    property string serverIp: "10.8.0.1"
    property string serverPort: "11434"
    property string model: "qwen3.5-16k"
    property var messages: []
    property bool busy: false
    property string error: ""

    function send(userInput) {
        const text = userInput.trim();
        if (text === "" || root.busy)
            return;

        root.messages = root.messages.concat([
            {
                role: "user",
                content: text
            }
        ]);
        root.busy = true;
        root.error = "";

        const body = JSON.stringify({
            model: root.model,
            messages: root.messages,
            stream: false
        });

        request.stdinEnabled = true;
        request.running = true;
        request.write(body);
        request.stdinEnabled = false; // EOF, so curl --data-binary @- returns
    }

    Process {
        id: request
        command: ["curl", "-sS", "--fail-with-body", "--max-time", "120", "-X", "POST", "-H", "Content-Type: application/json", "--data-binary", "@-", root.endpoint]

        stdout: StdioCollector {
            onStreamFinished: {
                root.busy = false;
                try {
                    const data = JSON.parse(text);
                    const message = data.choices?.[0]?.message ?? {};
                    let content = message.content ?? "";
                    if (content === "")
                        content = message.reasoning ?? message.reasoning_content ?? "";
                    if (content === "") {
                        root.error = data.error?.message ?? "empty reply";
                        return;
                    }
                    root.messages = root.messages.concat([
                        {
                            role: "assistant",
                            content
                        }
                    ]);
                    Quickshell.execDetached(["notify-send", "-a", "Agent", "Response Generated!"]);
                } catch (e) {
                    root.error = "bad response";
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text !== "")
                    root.error = text;
            }
        }
    }
}
