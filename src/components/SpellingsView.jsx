import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { questions } from '../data/spellings_data.json';
import { setSpellings } from './../reducers/mainReducer';
import Speech from 'react-speech';
import './Spellings.scss';
import axios from 'axios';
import Modal from 'react-modal';

const Main = () => {
    const dispatch = useDispatch();
    const { spellings } = useSelector(state => state.main);
    const [submitted, setSubmitted] = useState(false);
    const [score, setScore] = useState(0);
    const [modalOpen, setModalOpen] = useState(false);
    const [meanings, setMeanings] = useState([]);
    const [word, setWord] = useState('')

    let week = 22;

    useEffect(() => {
        dispatch(setSpellings(questions.filter((q) => q.group === week)))
    }, []);

    const doPlay = (event) => {
        event.preventDefault();
        event.currentTarget.children[0].children[0].firstChild.click();
    }

    const checkAns = (item, ans) => {
        if (document.getElementById(item)) {
            return document.getElementById(item).value.toLowerCase() === ans.toLowerCase()
        } else {
            return false
        }
    }

    const showMeaning = (word) => {
        axios.get('https://api.dictionaryapi.dev/api/v2/entries/en/' + word)
            .then(resp => {
                setMeanings(resp.data[0].meanings);
                setWord(word);
                setModalOpen(true);
            })
    }


    const onSubmit = (event) => {
        setScore(0);
        setSubmitted(true);
        let _score = 0;
        spellings.map((item, index) => {
            if (document.getElementById('Q' + index).value.toLowerCase() === item.q.toLowerCase()) {
                setScore(++_score);
            }
        })

    }

    return (
        <div className="spellings">
            <Modal
                isOpen={modalOpen}
                contentLabel="Dictionary"
            > <h1>{word}</h1>
                {
                    meanings.map((definitions, num) => {
                        return definitions.definitions.map((definition, index) => {
                            return <div>
                                <div className={`spellings__definitions${num % 2}`}><h3>Definition: {index + 1}<br /></h3></div>
                                {definition.definition}
                                <br />
                                <h4>Example: <br /></h4>
                                {definition.example}
                                <br />
                                <h4>Synonyms: <br /></h4>
                                <ul>
                                    {
                                        definition.synonyms ? definition.synonyms.map(synonym => {
                                            return <li>{synonym}</li>
                                        }) : '-'
                                    }</ul>
                            </div>
                        })
                    })
                }
                <br /><br /><br />
                <button className="btn btn-primary" onClick={() => setModalOpen(false)}>Close</button>
            </Modal>
            <h1 className="spellings__title">WEEK {week}</h1>
            { submitted && <h1>{`Your score is: ${(score / spellings.length * 100).toFixed(2)} %`}</h1>}
            {
                spellings ? spellings.map((quest, index) => {
                    const ans = checkAns('Q' + index, quest.q);

                    return <div className="spellings__question-div" >{`(${index + 1}) `}<i className='fa fa-volume-up spellings__container' onClick={(event) => doPlay(event)}>&nbsp;&nbsp;&nbsp;Click to Play<span className="spellings__speech"><Speech text={quest.q} voice="Google UK English Female" /></span></i>&nbsp;&nbsp;&nbsp;<input id={`Q` + index} type="text"></input>&nbsp;
                        {
                            submitted && ans === true &&
                            < i className="fa fa-check" style={{ 'font-size': '20px', 'color': 'green' }}></i>
                        }
                        {
                            submitted && ans !== true &&
                            < i className="fa fa-times" style={{ 'font-size': '20px', 'color': 'red' }}></i>
                        }
                        &nbsp;&nbsp;&nbsp;
                        {
                            submitted && <a className="spellings__showmeaning-button" onClick={() => showMeaning(quest.q)}>Show Meaning</a>}
                    </div >
                }) : null
            }
            <div className="buttonContainer">
                <button className="btn btn-primary" onClick={onSubmit}>Submit</button>
            </div>
        </div >
    )
}

export default Main;