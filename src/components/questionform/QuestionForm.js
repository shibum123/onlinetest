import React from 'react';
import { questions } from '../../data/data.json';

const QuestionForm = () => {

    const downloadJson = () => {
        const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(questions));
        const downloadAnchorNode = document.createElement('a');
        downloadAnchorNode.setAttribute("href", dataStr);
        downloadAnchorNode.setAttribute("download", "data.json");
        document.body.appendChild(downloadAnchorNode); // required for firefox
        downloadAnchorNode.click();
        downloadAnchorNode.remove();
    }

    const addquestions = () => {
        let ans = document.getElementById('option1Text').value;

        if (document.getElementById('option1').checked) {
            ans = document.getElementById('option1Text').value;
        } else if (document.getElementById('option2').checked) {
            ans = document.getElementById('option2Text').value;
        } else if (document.getElementById('option3').checked) {
            ans = document.getElementById('option3Text').value;
        } else if (document.getElementById('option4').checked) {
            ans = document.getElementById('option4Text').value;
        }

        const options = [
            document.getElementById('option1Text').value,
            document.getElementById('option2Text').value,
            document.getElementById('option3Text').value,
            document.getElementById('option4Text').value
        ]

        const questionObj = {
            "id": questions.length + 1,
            "q": document.getElementById('question').value !== null ? document.getElementById('question').value : null,
            "img": document.getElementById('questionImg').value !== null ? document.getElementById('questionImg').value : null,
            "group": 6,
            "attempted_count": 0,
            "wrong_count": 0,
            "options": options,
            "ans": ans
        }

        questions.push(questionObj);

        alert("Question submitted");
    }

    return <div>
        <h1>Question Form</h1>
        <label for="question">Question: {questions.length + 1}</label>&nbsp;&nbsp;&nbsp;
        <textarea id="question" name="question" rows="4" cols="80" />
        <br /><br />
        <label for="questionImg">Question Image:</label>&nbsp;&nbsp;&nbsp;
        <input type="text" id="questionImg" name="questionImg" cols="40" />
        <br />
        <br />
        <label for="option1">Option 1:</label>&nbsp;&nbsp;&nbsp;
        <input type="radio" id="option1" name="option" value="opt1" checked/>&nbsp;&nbsp;&nbsp;
        <input type="text" id="option1Text" />
        <br />
        <br />
        <label for="option1">Option 2:</label>&nbsp;&nbsp;&nbsp;
        <input type="radio" id="option2" name="option" value="opt2" />&nbsp;&nbsp;&nbsp;
        <input type="text" id="option2Text" />
        <br />
        <br />
        <label for="option1">Option 3:</label>&nbsp;&nbsp;&nbsp;
        <input type="radio" id="option3" name="option" value="opt3" />&nbsp;&nbsp;&nbsp;
        <input type="text" id="option3Text" />
        <br />
        <br />
        <label for="option1">Option 4:</label>&nbsp;&nbsp;&nbsp;
        <input type="radio" id="option4" name="option" value="opt4" />&nbsp;&nbsp;&nbsp;
        <input type="text" id="option4Text" />
        <br />
        <br />
        <button className="btn btn-warning" onClick={addquestions}>Add Question</button>&nbsp;&nbsp;
        <button className="btn btn-warning" onClick={downloadJson}>Download Questions</button>

    </div>
}

export default QuestionForm;